defmodule BlockChain do
  use GenServer
  @moduledoc """
  Documentation for BlockChain.
  """

  @doc """
  Hello world.

  ## Examples

      iex> BlockChain.hello()
      :world

  """
  def main(threshold) do
    threshold = String.to_integer(threshold)
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    minePendingTransactions(pid, "anip-address", threshold)
    IO.inspect(get_latest_block(pid))
  end
  def init([]) do
    timestamp = :erlang.system_time / 1.0e6 |> round
    {:ok, {[], 1, [], 0}}
  end

  def update_mining_reward(pid, {:updateMiningReward, reward}) do
    GenServer.cast(pid, {:updateMiningReward, reward})
  end
  def update_pending_transcations(pid, {:updatePendingTransactions, transactions}) do
    GenServer.cast(pid, {:updatePendingTransactions, transactions})
  end
  def add_block(pid, block_pid) do
    GenServer.cast(pid, {:addBlock, block_pid})
  end
  def get_pending_transactions(pid) do
    GenServer.call(pid, {:getPendingTransactions})
  end
  def get_chain(pid) do
    GenServer.call(pid, {:getChain})
  end
  def get_mining_reward(pid) do
    GenServer.call(pid, {:getMiningReward})
  end
  def get_latest_block(pid) do
    GenServer.call(pid, {:getLatestBlock})
  end
  # def is_chain_valid(pid) do
  #   chain = get_chain(pid)
  # end
  def add_transaction(pid, transaction) do
    GenServer.cast(pid, {:addTransaction, transaction})
  end
  def minePendingTransactions(pid, miningRewardAddress, threshold) do
    {:ok, block_pid} = Block.start_link()
    Block.mine_block(block_pid, threshold)
    latest_block_pid = get_latest_block(pid)
    latest_block_hash = Block.get_hash(latest_block_pid)
    Block.update_previous_hash(block_pid, latest_block_hash)
    add_block(pid, block_pid)
  end
  def handle_call({:getPendingTransactions}, _from, state) do
    {_, _, transactions, _} = state
    {:reply, transactions, state}
  end
  def handle_call({:getChain}, _from, state) do
    {chain, _, _, _} = state
    {:reply, chain, state}
  end
  def handle_call({:getMiningReward}, _from, state) do
    {_, _, _, reward} = state
    {:reply, reward, state}
  end
  def handle_call({:getLatestBlock}, _from, state) do
    {chain, _, _, _} = state
    latest_block = List.last(chain)
    {:reply, latest_block, state}
  end
  def handle_cast({:addTransaction, transaction}, state) do
    {a, b, transactions, d} = state
    state = {a, b, transactions ++ [transaction], d}
    {:noreply, state}
  end
  def handle_cast({:updateMiningReward, reward}, state) do
    {a, b, c, _} = state
    state = {a, b, c, reward}
    {:noreply, state}
  end
  def handle_cast({:updatePendingTransactions, transactions}, state) do
    {a, b, _, d} = state
    state = {a, b, transactions, d}
    {:noreply, state}
  end
  def handle_cast({:addBlock, block_pid}, state) do
    {chain, b, c, d} = state
    state = {chain ++ [block_pid], b, c, d}
    {:noreply, state}
  end
  def hello do
    :world
  end
end
