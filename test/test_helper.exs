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

ExUnit.start()
