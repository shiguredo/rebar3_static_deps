-module(rebar3_static_resource).

-behaviour(rebar_resource).

-export([lock/2,
         download/3,
         needs_update/2,
         make_vsn/1]).

lock(Dir, Source) ->
    rebar_git_resource:lock(Dir, Source).

download(Dir, Source, State) ->
    rebar_api:warn("Source=~p", [Source]),
    case rebar_git_resource:download(Dir, to_normal_resource(Source), State) of
        {error, Reason} ->
            {error, Reason};
        ok ->
            write_app_file(Dir);
        {ok, _} ->
            write_app_file(Dir)
    end.


needs_update(Dir, Source) ->
    rebar_git_resource:make_vsn(Dir, to_normal_resource(Source)).

make_vsn(Dir) ->
    rebar_git_resource:make_vsn(Dir).

%% private

to_normal_resource({static, Repo, Vsn}) ->
    {git, Repo, Vsn}.

write_app_file(Dir) ->
    rebar_api:warn("Dir=~p", [Dir]),
    ok.
    %% AppFilePath = filename:join([Dir, "src", "").
