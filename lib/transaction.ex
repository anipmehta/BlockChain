defmodule Transaction do
  use GenServer
  def init([from_address, to_address, amount]) do
    {:ok, {from_address, to_address, amount, None}}
  end
  def start_link(from_address, to_address, amount) do
    GenServer.start_link(__MODULE__, [from_address, to_address, amount])
  end
  def get_amount(pid) do
  GenServer.call(pid, {:getAmount})
  end
  def get_signature(pid) do
    GenServer.call(pid, {:getSign})
  end
  def verify_transaction(pid, user_public_key) do
    sign = get_signature(pid)
    amount = get_amount(pid)
    :crypto.verify(:ecdsa,:sha256,Float.to_string(amount),sign,[user_public_key,:secp256k1])
  end
  def get_from_address(pid) do
    GenServer.call(pid, {:getFromAddress})
  end
  def get_to_address(pid) do
    GenServer.call(pid, {:getToAddress})
  end
  def update_sign(pid, sign) do
    GenServer.cast(pid, {:updateSign, sign})
  end
  def handle_call({:getFromAddress}, _from, state) do
    {from_address, _, _, _} = state
    {:reply, from_address, state}
  end
  def handle_call({:getSign}, _from, state) do
    {_, _, _, sign} = state
    {:reply, sign, state}
  end
  def handle_call({:getToAddress}, _from, state) do
    {_, to_address, _, _} = state
    {:reply, to_address, state}
  end
  def handle_call({:getAmount}, _from, state) do
    {_, _, amount, _} = state
    {:reply, amount, state}
  end
  def handle_cast({:updateSign, sign}, state) do
    {a, b, c, _} = state
    state = {a, b, c, sign}
    {:noreply, state}
  end
end
