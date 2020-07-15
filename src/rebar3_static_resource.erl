-module(rebar3_static_resource).

-behaviour(rebar_resource_v2).

-export([init/2,
         lock/2,
         download/4,
         needs_update/2,
         make_vsn/2]).

init(Type, _State) ->
    rebar_api:debug("rebar3_static_resource:init(): Type=~p", [Type]),
    Resource = rebar_resource_v2:new(Type, ?MODULE, #{}),
    {ok, Resource}.

lock(AppInfo, ResourceState) ->
    {git, Url, Ref} = rebar_git_resource:lock(to_internal_app_info(AppInfo), ResourceState),
    {static, Url, Ref}.

download(Dir, AppInfo, ResourceState, State) ->
    rebar_api:debug("rebar3_static_resource:download(): AppInfo=~p", [AppInfo]),
    %% rebar_api:debug("rebar3_static_resource:download(): ResourceState=~p", [ResourceState]),
    case rebar_git_resource:download(Dir, to_internal_app_info(AppInfo), ResourceState, State) of
        {error, Reason} ->
            {error, Reason};
        ok = Res ->
            ok = write_app_src_file(Dir, AppInfo),
            Res;
        {ok, _} = Res ->
            ok = write_app_src_file(Dir, AppInfo),
            Res
    end.

needs_update(AppInfo, ResourceState) ->
    rebar_git_resource:needs_update(to_internal_app_info(AppInfo), ResourceState).

make_vsn(AppInfo, ResourceState) ->
    rebar_git_resource:make_vsn(to_internal_app_info(AppInfo), ResourceState).

%%%% private

to_internal_app_info(AppInfo) ->
    {static, Url, Ref} = rebar_app_info:source(AppInfo),
    rebar_app_info:source(AppInfo, {git, Url, Ref}).

write_app_src_file(Dir, AppInfo) ->
    rebar_api:dubug("rebar3_static_resource:write_app_file(): Dir=~p", [Dir]),
    AppName =  rebar_app_info:name(AppInfo),
    rebar_api:debug("rebar3_static_resource:write_app_file(): AppName=~p", [AppName]),
    AppFilePath = filename:join([Dir, "src", binary_to_list(AppName) ++ ".app.src"]),
    rebar_api:debug("rebar3_static_resource:write_app_file(): AppFilePath=~p", [AppFilePath]),
    ok = filelib:ensure_dir(AppFilePath),
    Content = <<"{application, ", (iolist_to_binary(AppName))/binary, ",\n",
                "  [{description, \"fake static app\"},\n",
                "   {vsn, \"0.1.0\"},\n",
                "   {registered, []},\n",
                "   {applications, [kernel, stdlib]},\n",
                "   {modules, []}]}.\n">>,
    rebar_api:debug("rebar3_static_resource:write_app_file(): AppFile content\n~ts", [Content]),
    ok = file:write_file(AppFilePath, Content),
    ok.
