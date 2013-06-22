%% 处理conn进程的回调函数.
-module(player).
-compile([export_all]).

-include("proto.hrl").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 进程退出时的一些回调.

join(_UID) ->
  %% join chat channel
  ok.

quit(_Reason, _State) ->
  data:guard_f(),
  %% quit chat channel
  ok.

cast(C, State) ->
  io:format("cast ~p~n", [C]),
  State.

info(C, State) ->
  io:format("info ~p~n", [C]),
  State.

call(C, From, State) ->
  io:format("call ~p from ~p~n", [C, From]),
  State.

send(Api, PT) ->
  conn:send(Api, PT).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 逻辑代码

code_ack(Api, Code) ->
  ApiI = proto_api:key(Api),
  CodeInt = proto_error:key(Code),
  Common = #pt_code{code=CodeInt, api=ApiI},
  conn:send(code_ack, Common),
  ok.

%% 各种cache函数，使用同一函数名，方便优化.
cache(user, UsrId) ->
  {ok, U} = data:lookup_s(users, UsrId),
  send(users_cah, U);
cache(building, UsrId) ->
  {ok, Buildings} = data:lookup_a(buildings, UsrId),
  send(buildings_cah, #db_buildings{buildings=Buildings}).
