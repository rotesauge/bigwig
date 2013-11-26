%%
%% show details on a specific process
%%
-module(bigwig_http_lager).
-behaviour(cowboy_http_handler).
-export([init/3, handle/2, terminate/3]).

init({tcp, http}, Req, _Opts) ->
    {ok, Req, undefined_state}.

handle(Req0, State) ->
    {Path, Req} = cowboy_req:path(Req0),
    {Method, Req1} = cowboy_req:method(Req),
    io:format("Path is ~p,Method is ~p",[Path,Method]),
    Path1=lists:delete(<<>>,binary:split(Path,[<<"/">>],[global])),
    handle_path(Method, Path1, Req1, State).

handle_path(<<"GET">>, [<<"lager">>, <<"status">>], Req, State) ->
    handle_get_status(Req, State);
handle_path(<<"GET">>, [<<"lager">>, <<"tracer">>, RoutingKey], Req, State) ->
    handle_get_log(RoutingKey, Req, State);
handle_path(<<"PUT">>, [<<"lager">>, <<"tracer">>, Tracer], Req, State) ->
    handle_add_tracer(Tracer, Req, State);
handle_path(<<"DELETE">>, [<<"lager">>, <<"tracer">>, Tracer], Req, State) ->
    not_found(Req, State);
handle_path(_, _, Req, State) ->
    not_found(Req, State).

handle_get_status(Req,State) ->
  Status = lager:status(),
  Status1 = remove(Status),
  Body = jsx:term_to_json(Status1),
  Headers = [{<<"Content-Type">>, <<"application/json">>}],
  {ok, Req2} = cowboy_req:reply(200, Headers, Body, Req),
  {ok, Req2, State}.
handle_get_log(RoutingKey, Req, State) ->
  {ok,Info}=file:read_file("trace.log"),
  Msg=[{bigwig_trace, Info}],
  Body = jsx:term_to_json(Msg),
  Headers = [{<<"Content-Type">>, <<"application/json">>}],
  {ok, Req2} = cowboy_req:reply(200, Headers, Body, Req),
  {ok, Req2, State}.
handle_add_tracer(Tracer, Req, State) ->
io:format("tracer is ~p", [Tracer]),
amqp_tracer:start_link(),
  case Tracer of
     {distributed, RoutingKey, Filter, Level} ->
          RoutingKey1=atom_to_binary(RoutingKey,utf8),
          amqp_tracer:trace_amqp(distributed, RoutingKey1, Filter, Level);
     {RoutingKey, Filter} ->
          RoutingKey1=atom_to_binary(RoutingKey,utf8),
          amqp_tracer:trace_amqp(RoutingKey1, Filter);
     {RoutingKey, Filter, Level} ->
          RoutingKey1=atom_to_binary(RoutingKey,utf8),
          amqp_tracer:trace_amqp(RoutingKey1, Filter, Level)
  end,
  {ok,Req,State}.
not_found(Req, State) ->
    {ok, Req2} = cowboy_req:reply(404, [], <<"<h1>404</h1>">>, Req),
    {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
    ok.

remove(Status) ->
   [_,LStatus,_,Traces,Reductions,_] = Status,
   LStatus1=lists:delete([],LStatus),
   [_, Reductions1] = Reductions,
   Reductions2 = lists:delete("\n",Reductions1),
   Status1 = [
               {<<"Lager status">>, LStatus1}, 
               {<<"ActiveTraces">>, Traces}, 
               {<<"Tracing Reductions">>,Reductions2}
               ],
   Status1.