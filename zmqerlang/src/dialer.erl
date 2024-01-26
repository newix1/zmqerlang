-module(dialer).
-export([start_server/0]).

start_server() ->
    {ok, Context} = erlzmq:context(),
    {ok, Socket} = erlzmq:socket(Context, rep),
    ok = erlzmq:bind(Socket, "tcp://127.0.0.1:8091"),

    handle(Socket).

%% Displaying in shell
handle(Socket) ->
    {ok, Msg} = erlzmq:recv(Socket),
    io:format("Server got message: ~p~n", [Msg]),
    handle(Socket).
