-module(subscriber).

-export([start/0, send/2, client/0, handle/1]).

start() ->
    spawn(?MODULE, client, []).

client() ->
    io:format("Client connects to server"),
    {ok, Context} = erlzmq:context(),
    {ok, Socket} = erlzmq:socket(Context, req),
    ok = erlzmq:connect(Socket, "tcp://127.0.0.1:8091"),
    handle(Socket).

send(Pid, Msg) ->
    Pid ! {send, Msg},
    ok.

handle(Socket) ->
    receive
        {send, Msg} ->
            io:format("Client send ~p~n", [Msg]),
            ok = erlzmq:send(Socket, [Msg]),
            handle(Socket)
    after 200 ->
            handle(Socket)
    end.

