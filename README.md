A rebar3 plugin to enable a non-Erlang deps specification.

# Plugin Configuration

```
{plugins,
 [
  {rebar3_static_deps, {git, "git://github.com/shiguredo/rebar3_static_deps.git", {tag, "0.1.1"}}}
 ]}.
```

# Resource Specification

```
{deps, [
        {bar, {static, "git@github.com:foo/bar.git", {tag, "0.1"}}}
       ]}.
```

# Limitation

- Underlying resources is restricted to git resources.

# License

```
Copyright 2020-2021, Shunichi Shinohara (Original Author)
Copyright 2020-2021, Shiguredo Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
