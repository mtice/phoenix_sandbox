https://hexdocs.pm/phoenix/up_and_running.html

issues:
if `mix local.rebar` hangs forever, clone rebar3 here: - `https://github.com/erlang/rebar3.git`
then:
- `cd rebar3`
- `./bootstrap`
- `rebar3 local install`
  
Then go back to your hello folder and do:

`mix local.rebar rebar3 ~/cache/rebar3/bin/rebar3`



On `mix ecto.create` if you see:
```
08:54:13.879 [error] GenServer #PID<0.213.0> terminating
** (Postgrex.Error) FATAL 28000 (invalid_authorization_specification) role "postgres" does not exist
    (db_connection) lib/db_connection/connection.ex:84: DBConnection.Connection.connect/2
    (connection) lib/connection.ex:622: Connection.enter_connect/5
    (stdlib) proc_lib.erl:249: :proc_lib.init_p_do_apply/3
Last message: nil
State: Postgrex.Protocol
** (Mix) The database for Hello.Repo couldn't be created: killed
```
do this: `createuser -d postgres`