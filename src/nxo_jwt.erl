-module(nxo_jwt).

-export([ verify/1, verify/2 ]).
-include_lib("jose/include/jose_jwt.hrl").

-define(GOOGLE_CERTS,
        "https://www.gstatic.com/iap/verify/public_key").

verify(JWT) ->
  verify(JWT, true).

verify(JWT, CheckExpiration) ->
  Key = google_key(kid(JWT)),
  case jose_jwt:verify(Key, JWT) of
    {true, Jose_JWT, _} ->
      Claims = Jose_JWT#jose_jwt.fields,
      case CheckExpiration =:= false orelse
        maps:get(<<"exp">>, Claims) > os:system_time(second) of
        true -> {true, Claims};
        false -> {false, jwt_expired}
      end;
    _ ->
      {false, cannot_verify_signature}
  end.


kid(JWT) ->
  [H, _] = binary:split(JWT, <<".">>),
  Header = jiffy:decode(base64:decode(H), [return_maps]),
  #{<<"kid">> := Kid} = Header,
  Kid.


google_key(Kid) ->
  Timeout = 60 * 60 * 1000,
  nitro_cache:get(jwt_certs, Timeout, Kid,
                  fun() -> fetch_google_key(Kid) end).


fetch_google_key(Kid) ->
  {ok, {{_, 200, _}, _, RawCerts}} = httpc:request(?GOOGLE_CERTS),
  CertMap = jiffy:decode(RawCerts, [return_maps]),
  Key = maps:get(Kid, CertMap),
  jose_jwk:from_pem(Key).
