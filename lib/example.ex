defmodule Example do
  def start_link() do
    MyGenserver.start_link(__MODULE__, :ok)
  end

  def expensive(pid, num) do
    MyGenserver.cast(pid, {:expensive, num})
  end

  def light(pid, num) do
    MyGenserver.cast(pid, {:light, num})
  end

  def show(pid) do
    MyGenserver.call(pid, :show)
  end

  def stop_server(pid) do
    MyGenserver.stop(pid, :other)
  end

  def init(:ok) do
    {:ok, 0}
  end

  def handle_call(:show, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:expensive, num}, state) do
    expensive_function()
    {:noreply, state + num}
  end

  def handle_cast({:light, num}, state) do
    {:noreply, state + num}
  end

  def handle_info({:add, num}, state) do
    {:noreply, state + num}
  end

  def terminate(reason, _state) do
    IO.inspect(reason, label: "Terminate Reason: ")
  end

  defp expensive_function do
    Enum.map(1..10_000_000, &(&1 * &1))
  end
end
