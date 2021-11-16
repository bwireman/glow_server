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

      @spec call(GenServer.server(), unquote(server).request(), integer()) ::
              unquote(server).response()
      def call(pid, request, timeout \\ 5), do: GenServer.call(pid, request, timeout)

      @spec cast(GenServer.server(), unquote(server).request()) :: unquote(server).response()
      def cast(pid, request), do: GenServer.cast(pid, request)

      @impl GenServer
      @spec handle_call(unquote(server).request(), GenServer.from(), unquote(server).state()) ::
              any()
      def handle_call(request, _from, state),
        do:
          :glow_server@core.build_call(request, state)
          |> unquote(server).dispatch

      @impl GenServer
      @spec handle_cast(unquote(server).request(), unquote(server).state()) :: any()
      def handle_cast(request, state),
        do:
          :glow_server@core.build_cast(request, state)
          |> unquote(server).dispatch

      @impl GenServer
      def handle_info(_, state), do: :glow_server@core.build_noreply(state)
    end
  end
end
