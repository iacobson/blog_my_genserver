defmodule ExampleTest do
  use ExUnit.Case

  test "handle_call" do
    {:ok, pid} = Example.start_link()

    Example.expensive_call(pid, 1, 1)
    Example.light_call(pid, 2, 2)

    assert Example.get_state(pid) == 3
  end

  test "handle_cast" do
    {:ok, pid} = Example.start_link()

    Example.expensive_cast(pid, 1, 1)
    Example.light_cast(pid, 2, 2)

    assert Example.get_state(pid) == 3
  end

  test "handle_info" do
    {:ok, pid} = Example.start_link()

    send(pid, {:expensive, 1, 1})
    send(pid, {:light, 2, 2})

    assert Example.get_state(pid) == 3
  end

  test "stop" do
    {:ok, pid} = Example.start_link()
    Process.monitor(pid)
    reason = :custom_reason

    assert Process.alive?(pid)
    Example.stop_server(pid, reason)
    assert_receive {:DOWN, _, _, _, ^reason}
    refute Process.alive?(pid)
  end

  test "combine callbacks" do
    {:ok, pid} = Example.start_link()
    Example.expensive_call(pid, 1, 1)
    Example.expensive_cast(pid, 2, 2)
    send(pid, {:expensive, 3, 3})
    send(pid, {:light, 4, 4})
    Example.light_cast(pid, 5, 5)
    Example.light_call(pid, 6, 6)

    assert Example.get_state(pid) == 21
  end
end
