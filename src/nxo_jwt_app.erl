%%%-------------------------------------------------------------------
%% @doc nxo_jwt public API
%% @end
%%%-------------------------------------------------------------------

-module(nxo_jwt_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    nxo_jwt_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
