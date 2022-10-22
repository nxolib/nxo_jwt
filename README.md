nxo_jwt
=====

A trivial application to verify JWTs issued by the Google IAP.

Usage
-----

``` erlang
Token = <<"eyJhbGc...">>.
{true, Claims} = nxo_jwt:verify(Token).
```

Author
------

Bunny Lushington
