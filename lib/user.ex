defmodule User do
  use GenServer
  def init([]) do
     {public_key, private_key} = :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1))
     {:ok, {private_key, public_key, 0.0}}
  end
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end
  def get_private_key(pid) do
    GenServer.call(pid, {:getPrivateKey})
  end
  def get_public_key(pid) do
    GenServer.call(pid, {:getPublicKey})
  end
  def get_amount(pid) do
    GenServer.call(pid, {:getAmount})
  end
  def update_amount(pid, amount) do
    GenServer.cast(pid, {:updateAmount, amount})
  end
  def handle_call({:getPrivateKey}, _from, state) do
    {private_key, _, _} = state
    {:reply, private_key, state}
  end
  def handle_call({:getPublicKey}, _from, state) do
    {_, public_key, _} = state
    {:reply, public_key, state}
  end
  def handle_call({:getAmount}, _from, state) do
    {_, _ , amount} = state
    {:reply, amount, state}
  end
  def handle_cast({:updateAmount, amount}, state) do
    {a, b, _} = state
    state = {a, b, amount}
    {:noreply, state}
  end
end
