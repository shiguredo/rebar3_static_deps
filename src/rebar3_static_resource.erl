-module(rebar3_static_resource).

-behaviour(rebar_resource_v2).

-export([init/2,
         lock/2,
         download/4,
         needs_update/2,
         make_vsn/2]).

init(Type, State) ->
    rebar_api:warn("rebar3_static_resource:init(): Type=~p", [Type]),
    Internal = rebar_git_resource:init(to_internal_type(Type), State),
    Resource = rebar_resource_v2:new(Type, ?MODULE, #{internal => Internal}),
    {ok, Resource}.

lock(AppInfo, ResourceState) ->
    rebar_git_resource:lock(AppInfo, ResourceState).

download(Dir, AppInfo, ResourceState, State) ->
    rebar_api:warn("rebar3_static_resource:download(): AppInfo=~p", [AppInfo]),
    rebar_api:warn("rebar3_static_resource:download(): ResourceState=~p", [ResourceState]),
    case rebar_git_resource:download(Dir, AppInfo, ResourceState, State) of
        {error, Reason} ->
            {error, Reason};
        ok ->
            write_app_file(Dir, AppInfo);
        {ok, _} ->
            write_app_file(Dir, AppInfo)
    end.


needs_update(AppInfo, ResourceState) ->
    rebar_git_resource:make_vsn(AppInfo, to_normal_resource(ResourceState)).

make_vsn(AppInfo, ResourceState) ->
    rebar_git_resource:make_vsn(AppInfo, ResourceState).

%% private

to_normal_resource({static, Repo, Vsn}) ->
    {git, Repo, Vsn}.

to_internal_type(static) ->
    git.

write_app_file(Dir, {_, Repo, _}) ->
    rebar_api:warn("rebar3_static_resource:write_app_file(): Dir=~p", [Dir]),
    AppName = lists:flatten(string:replace(filename:basename(Repo, ".git"), "-", "_", all)),
    AppFilePath = filename:join([Dir, "src", AppName ++ ".app.src"]),
    rebar_api:warn("rebar3_static_resource:write_app_file(): AppFilePath=~p", [AppFilePath]),
    ok = filelib:ensure_dir(AppFilePath),
    Content = <<"{application, ", (iolist_to_binary(AppName))/binary, ",\n",
                "  [{description, \"fake static app\"},\n",
                "   {vsn, \"0.1.0\"},\n",
                "   {registered, []},\n",
                "   {applications, [kernel, stdlib]},\n",
                "   {modules, []}]}.\n">>,
    rebar_api:warn("rebar3_static_resource:write_app_file(): AppFile content\n~ts", [Content]),
    ok = file:write_file(AppFilePath, Content),
    ok.
