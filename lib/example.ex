defmodule Example do
  # API

  def start_link() do
    MyGenserver.start_link(__MODULE__, :ok)
  end

  def expensive_call(pid, num, order) do
    IO.inspect(order, label: "REQUEST ORDER: ")
    MyGenserver.call(pid, {:expensive, num, order})
  end

  def light_call(pid, num, order) do
    IO.inspect(order, label: "REQUEST ORDER: ")
    MyGenserver.call(pid, {:light, num, order})
  end

  def expensive_cast(pid, num, order) do
    IO.inspect(order, label: "REQUEST ORDER: ")
    MyGenserver.cast(pid, {:expensive, num, order})
  end

  def light_cast(pid, num, order) do
    IO.inspect(order, label: "REQUEST ORDER: ")
    MyGenserver.cast(pid, {:light, num, order})
  end

  def get_state(pid) do
    MyGenserver.call(pid, :get_state)
  end

  def stop_server(pid, reason \\ :normal) do
    MyGenserver.stop(pid, reason)
  end

  # CALLBACKS

  def init(:ok) do
    {:ok, 0}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:expensive, num, order}, _from, state) do
    IO.inspect(order, label: "PROCESS ORDER: ")
    expensive_function()
    {:reply, :ok, state + num}
  end

  def handle_call({:light, num, order}, _from, state) do
    IO.inspect(order, label: "PROCESS ORDER: ")
    {:reply, :ok, state + num}
  end

  def handle_cast({:expensive, num, order}, state) do
    IO.inspect(order, label: "PROCESS ORDER: ")
    expensive_function()
    {:noreply, state + num}
  end

  def handle_cast({:light, num, order}, state) do
    IO.inspect(order, label: "PROCESS ORDER: ")
    {:noreply, state + num}
  end

  def handle_info({:expensive, num, order}, state) do
    IO.inspect(order, label: "PROCESS ORDER: ")
    expensive_function()
    {:noreply, state + num}
  end

  def handle_info({:light, num, order}, state) do
    IO.inspect(order, label: "PROCESS ORDER: ")
    {:noreply, state + num}
  end

  def terminate(reason, _state) do
    IO.inspect(reason, label: "Terminate Reason: ")
  end

  # IMPL

  defp expensive_function do
    Enum.map(1..10_000_000, &(&1 * &1))
  end
end
