%%%-------------------------------------------------------------------
%% @doc nxo_jwt top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(nxo_jwt_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  {ok, _} = application:ensure_all_started(inets),
  {ok, _} = application:ensure_all_started(ssl),
  {ok, _} = application:ensure_all_started(nitro_cache),
  nitro_cache:init(jwt_certs),

  SupFlags = #{strategy => one_for_all,
               intensity => 0,
               period => 1},
  ChildSpecs = [],
  {ok, {SupFlags, ChildSpecs}}.

%% internal functions
