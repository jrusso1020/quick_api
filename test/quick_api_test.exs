defmodule QuickApiTest do
  use ExUnit.Case
  doctest QuickApi

  test "greets the world" do
    assert QuickApi.hello() == :world
  end
end
