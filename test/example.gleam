import glow_server/core
import gleam/io
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
