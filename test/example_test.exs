defmodule ExampleTest do
  use ExUnit.Case

  test "greets the world" do
    {:ok, pid} = Example.start_link()
    Process.monitor(pid)

    Example.expensive(pid, 1)
    assert Example.show(pid) == 1
    Example.light(pid, 1)

    assert Example.show(pid) == 2
    send(pid, {:add, 1})
    assert Example.show(pid) == 3

    assert Process.alive?(pid)
    Example.stop_server(pid)
    assert_receive {:DOWN, _, _, _, reason}
    refute Process.alive?(pid)
  end
end
