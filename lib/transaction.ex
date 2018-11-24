defmodule Transaction do
  use GenServer
  def init([from_address, to_address, amount]) do
    {:ok, {from_address, to_address, amount}}
  end
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end
  def get_amount(pid) do
  GenServer.call(pid, :getAmount)
  end
  def get_from_adress(pid) do
    GenServer.call(pid, :getFromAddress)
  end
  def get_to_address(pid) do
    GenServer.call(pid, :getToAddress)
  end
  def handle_call({:getFromAddress}, _from, state) do
    {from_address, _, _} = state
    {:reply, from_address, state}
  end
  def handle_call({:getToAddress}, _from, state) do
    {_, to_address, _} = state
    {:reply, to_address, state}
  end
  def handle_call({:getAmount}, _from, state) do
    {_, _, amount} = state
    {:reply, amount, state}
  end
end
