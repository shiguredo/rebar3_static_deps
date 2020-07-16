A rebar3 plugin to enable a non-Erlang deps specification.

# Plugin Configuration

```
{plugins,
 [
  {rebar3_static_deps, {git, "git://github.com/shino/rebar3_static_deps.git", {tag, "0.1.0"}}}
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

