defmodule GlowServerTest do
  use ExUnit.Case, async: true

  setup do
    glow = start_supervised!(ExampleGlowServer)
    %{glow: glow}
  end

  test "ExampleGlowServer", %{glow: _} do
    assert "initial-state" == ExampleGlowServer.read()
    assert "the initial-state" == ExampleGlowServer.concat("the ")
    ExampleGlowServer.clear()
    assert "" == ExampleGlowServer.read()
    ExampleGlowServer.set("new-state")
    assert "new-state" == ExampleGlowServer.read()
    ExampleGlowServer.reverse()
    assert "etats-wen" == ExampleGlowServer.read()
    ExampleGlowServer.reverse()
    assert "new-state" == ExampleGlowServer.read()
    ExampleGlowServer.clear()
    assert "" == ExampleGlowServer.read()
  end
end
