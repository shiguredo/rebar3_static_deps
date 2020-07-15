-module(rebar3_static_resource).

-behaviour(rebar_resource_v2).

-export([lock/2,
         download/3,
         needs_update/2,
         make_vsn/1]).

lock(Dir, Source) ->
    rebar_git_resource:lock(Dir, to_normal_resource(Source)).

download(Dir, Source, State) ->
    rebar_api:warn("Source=~p", [Source]),
    case rebar_git_resource:download(Dir, to_normal_resource(Source), State) of
        {error, Reason} ->
            {error, Reason};
        ok ->
            write_app_file(Dir, Source);
        {ok, _} ->
            write_app_file(Dir, Source)
    end.


needs_update(Dir, Source) ->
    rebar_git_resource:make_vsn(Dir, to_normal_resource(Source)).

make_vsn(Dir) ->
    rebar_git_resource:make_vsn(Dir).

%% private

to_normal_resource({static, Repo, Vsn}) ->
    {git, Repo, Vsn}.

write_app_file(Dir, {_, Repo, _}) ->
    rebar_api:warn("Dir=~p", [Dir]),
    AppName = lists:flatten(string:replace(filename:basename(Repo, ".git"), "-", "_", all)),
    AppFilePath = filename:join([Dir, "src", AppName ++ ".app.src"]),
    rebar_api:warn("AppFilePath=~p", [AppFilePath]),
    ok = filelib:ensure_dir(AppFilePath),
    Content = <<"{application, ", (iolist_to_binary(AppName))/binary, ",\n",
                "  [{description, \"fake static app\"},\n",
                "   {vsn, \"0.1.0\"},\n",
                "   {registered, []},\n",
                "   {applications, [kernel, stdlib]},\n",
                "   {modules, []}]}.\n">>,
    rebar_api:warn("AppFile content=~p", [Content]),
    ok = file:write_file(AppFilePath, Content),
    ok.
