defmodule RawgExTest do
  use ExUnit.Case
  doctest RawgEx

  test "starts" do
    {:ok, pid} = RawgEx.start_link(name: :test)
    assert pid |> is_pid()
  end
end
