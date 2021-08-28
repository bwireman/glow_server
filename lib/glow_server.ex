defmodule GlowServer do
  defmacro __using__(opts) do
    server = Access.get(opts, :server)

    if server == nil do
      raise """
      \nGlowServer must be passed the module of the implementing core server!

      Example:
      defmodule Foo do
        use GlowServer, server: :glow_server@example

        ...
      end
      """
    end

    quote bind_quoted: [server: server] do
      use GenServer

      @spec call(GenServer.server(), __MODULE__.glow_req_t(), integer()) ::
              __MODULE__.glow_resp_t()
      def call(pid, request, timeout \\ 5), do: GenServer.call(pid, request, timeout)

      @spec cast(GenServer.server(), __MODULE__.glow_req_t()) :: __MODULE__.glow_resp_t()
      def cast(pid, request), do: GenServer.cast(pid, request)

      @impl GenServer
      def handle_call(request, _from, state),
        do:
          :glow_server@core.build_call(request, state)
          |> unquote(server).dispatch

      @impl GenServer
      def handle_cast(request, state),
        do:
          :glow_server@core.build_cast(request, state)
          |> unquote(server).dispatch

      @impl GenServer
      def handle_info(_, state), do: :glow_server@core.build_noreply(state)
    end
  end
end
