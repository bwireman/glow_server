# GlowServer

Defines macros to use GenServers where the core logic is defined in Gleam

## Usage

```elixir
defmodule Foo do
  use GlowServer, server: :glow_server@example

  # the request type of this GlowServer
  @type glow_req_t :: integer()
  
  # the response type of this GlowServer
  @type glow_resp_t :: String.t()

  def start_link(_) do
    GenServer.start_link(__MODULE__, "initial-state", name: __MODULE__)
  end

  # call and cast are defined by GlowServer and have specs matching
  # glow_req_t and glow_resp_t
  def foo(i), do: call(__MODULE__, i)
  def bar(i), do: cast(__MODULE__, i)

  def init(init_arg) do
    {:ok, init_arg}
  end
end
```

The `GlowServer.__using__` macro takes in the name of the implementing server and defines 
`call` & `cast` which are forwarded to the server's `dispatch` function  

