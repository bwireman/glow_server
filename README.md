# GlowServer

Defines macros to use GenServers where the core logic is defined in Gleam

## Usage

```elixir
# elixir server API 
defmodule ExampleGlowServer do
  use GlowServer, server: :example

  def start_link(_), do: GenServer.start_link(__MODULE__, "initial-state", name: __MODULE__)

  def init(init_arg), do: {:ok, init_arg}

  def read(), do: call(__MODULE__, :read)

  def reverse(), do: cast(__MODULE__, :reverse)

  def clear(), do: set("")

  def set(s), do: cast(__MODULE__, {:set, s})

  def concat(s), do: call(__MODULE__, {:concat, s})
end
```

The `GlowServer.__using__` macro takes in the name of the implementing server and defines 
`call` & `cast` which are forwarded to the server's `dispatch` function  


```gleam
// core logic in gleam
import glow_server/core
import gleam/string

pub type Request {
  Read
  Reverse
  Concat(String)
  Set(String)
}

pub type Response =
  String

pub type State =
  String

pub fn dispatch(
  request: core.Request(Request, State),
) -> core.Response(Response, State) {
  case request {
    core.Call(Read, state) -> core.build_reply(state, state)

    core.Cast(Reverse, state) -> core.build_noreply(string.reverse(state))

    core.Call(Concat(s), state) ->
      core.build_reply(string.concat([s, state]), s)

    core.Cast(Set(s), _state) -> core.build_noreply(s)
  }
}
```