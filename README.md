# GlowServer

Defines macros to use GenServers where the core logic is defined in Gleam

## Usage

```elixir
# elixir server API 
defmodule ExampleGlowServer do
  use GlowServer, server: :example

  # the request type used by the server
  @type glow_req_t :: :read | {:set, String.t()} | {:concat, String.t()} | :reverse
  
  # the response type returned by the server
  @type glow_resp_t :: String.t()

  # the internal state type of the server
  @type glow_state_t :: String.t()

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


```rust
// core logic in gleam
import glow_server/core
import gleam/string

pub type ExampleRequestType {
  Read
  Reverse
  Concat(String)
  Set(String)
}

pub fn dispatch(
  request: core.Request(ExampleRequestType, String),
) -> core.Response(String, String) {
  case request {
    core.Call(Read, state) -> core.build_reply(state, state)

    core.Cast(Reverse, state) -> core.build_noreply(string.reverse(state))

    core.Call(Concat(s), state) -> {
      let resp = string.concat([s, state])
      let new_state = s
      core.build_reply(resp, new_state)
    }

    core.Cast(Set(s), _state) -> core.build_noreply(s)
  }
}
```