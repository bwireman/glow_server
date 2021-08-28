pub type Request(request_type, state_type) {
  Call(request: request_type, state: state_type)
  Cast(request: request_type, state: state_type)
}

pub type Response(response_type, state_type) {
  Reply(response: response_type, state: state_type)
  Noreply(state: state_type)
}

pub fn build_call(request: request_type, state: state_type) {
  Call(request, state)
}

pub fn build_cast(request: request_type, state: state_type) {
  Cast(request, state)
}

pub fn build_reply(response: response_type, state: state_type) {
  Reply(response, state)
}

pub fn build_noreply(state: state_type) {
  Noreply(state)
}
