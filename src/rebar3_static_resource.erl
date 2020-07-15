-module(rebar3_static_resource).

-behaviour(rebar_resource).

-export([lock/2,
         download/3,
         needs_update/2,
         make_vsn/1]).

lock(Dir, Source) ->
    rebar_git_resource:lock(Dir, Source).

download(Dir, Source, State) ->
    rebar_git_resource:download(Dir, Source, State).

needs_update(Dir, Source) ->
    rebar_git_resource:make_vsn(Dir, Source).

make_vsn(Dir) ->
    rebar_git_resource:make_vsn(Dir).
