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

### views ~= page adapters. Manipulate controller data for a template (presentation layer)

### Templates are Embedded Elixir (.eex)
- automatic escaping of values (cross site scripting protection)
- scoped to a view, which are scoped to a controller.
  
##Pattern Matching
##### https://elixir-lang.org/getting-started/pattern-matching.html
 = can be used as assigns, but really it's the **match** operator
 ```
 iex> {a, b, c} = {:hello, "world", 42}
{:hello, "world", 42}
iex> a
:hello
iex> b
"world"

iex> {a, b, c} = {:hello, "world"}
** (MatchError) no match of right hand side value: {:hello, "world"}
 ```
## Routing
route checker-outer : `mix phx.routes`
Produces this:
```
page_path  GET  /                  HelloWeb.PageController :index
hello_path  GET  /hello             HelloWeb.HelloController :index
hello_path  GET  /hello/:messenger  HelloWeb.HelloController :show
```
### resource macro is freekin sweet. 
`resources "/users", UserController` produces:
```
user_path  GET     /users           HelloWeb.UserController :index
user_path  GET     /users/:id/edit  HelloWeb.UserController :edit
user_path  GET     /users/new       HelloWeb.UserController :new
user_path  GET     /users/:id       HelloWeb.UserController :show
user_path  POST    /users           HelloWeb.UserController :create
user_path  PATCH   /users/:id       HelloWeb.UserController :update
           PUT     /users/:id       HelloWeb.UserController :update
user_path  DELETE  /users/:id       HelloWeb.UserController :delete
```
Can also be selective: `resources "/users", UserController, only: [:index, :show]`
or
`resources "/comments", CommentController, except: [:delete]`

*Note: UserController doesn't even need to be defined first*

#### Can Nest
```
resources "/users", UserController do
  resources "/posts", PostController
end
```

### forward macro
`forward "/jobs", BackgroundJob.Plug` send all /jobs urls through BackgroundJob.Plug logic. 
`forward "/jobs", BackgroundJob.Plug, name: "Some paramater"` send in paramater. 
can use in pipeline like:
```
scope "/" do
    pipe_through [:authenticate_user, :ensure_admin]
    forward "/jobs", BackgroundJob.Plug
  end
```
^^ this means plugs in `authenticate_user` and `ensure_admin` will be called before `BackgroundJob.Plug`

### Path Helpers
just go here: https://hexdocs.pm/phoenix/routing.html#path-helpers
- Defined in Router.Helpers module. 
- Names are derived from Controller used in Route definition.
   e.g. HelloWeb.PageController has a `page_path` function that returns root path of App. `HelloWeb.Router.Helpers.page_path(HelloWeb.Endpoint, :index)`
- Can use this in templates like `<a href="<%= Routes.page_path(@conn, :index) %>">To the Welcome Page!</a>`
  
`Routes.user_path(Endpoint, :show, 17)` = "/users/17"
`Routes.user_path(Endpoint, :show, 17, admin: true, active: false)` = "/users/17?admin=true&active=false"
`Routes.user_url(Endpoint, :index)` = "http://localhost:4000/users"

```
<h5><span>ITEM: <%= get_in(item, ["item"])%></span>
        <span>WEIGHT: <%= get_in(item, ["weight"])%></span>
        <span>POS: <%= get_in(item, ["pos"])%></span></h5>
```
