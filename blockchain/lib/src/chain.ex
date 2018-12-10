defmodule Chain do
  use GenServer
  def main(threshold) do
    threshold = String.to_integer(threshold)
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    update_mining_reward(pid, 100.0)
    {:ok, user_a_id} = User.start_link()
    add_user(pid, user_a_id)
    mine_pending_transactions(pid, User.get_public_key(user_a_id), threshold)
    # IO.inspect(User.get_public_key(user_a_id))
    {:ok, user_b_id} = User.start_link()
    add_user(pid, user_b_id)
    {:ok, txn_a_id} = Transaction.start_link(User.get_public_key(user_a_id), User.get_public_key(user_b_id), 100.00)
    User.sign_transaction(user_a_id, txn_a_id)
    add_transaction(pid, txn_a_id)
    {:ok, txn_b_id} = Transaction.start_link(User.get_public_key(user_b_id), User.get_public_key(user_a_id), 100.00)
    User.sign_transaction(user_b_id, txn_b_id)
    add_transaction(pid, txn_b_id)
    # IO.inspect(txn_a_id)
    # IO.inspect(Transaction.get_amount(txn_a_id))
    IO.inspect("original balances.....")
    IO.inspect(User.get_amount(user_a_id))
    IO.inspect(User.get_amount(user_b_id))
    block_2_pid = mine_pending_transactions(pid, User.get_public_key(user_b_id), threshold)
    IO.inspect(Block.is_valid(block_2_pid))
    IO.inspect("updated balances.....")
    IO.inspect(User.get_amount(user_a_id))
    IO.inspect(User.get_amount(user_b_id))
    IO.inspect(is_valid(pid))
    IO.inspect(get_balance(pid, User.get_public_key(user_a_id)))
    IO.inspect(get_balance(pid, User.get_public_key(user_b_id)))

    # IO.inspect(Block.get_transactions(block_2_pid))
    # IO.inspect(get_pending_transactions(pid))
  end
  def init([]) do
    timestamp = :erlang.system_time / 1.0e6 |> round
    genesis_block = create_genesis_block()
    {:ok, {[] ++ [genesis_block], 1, [], 0, %{}}}
  end
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def update_mining_reward(pid, reward) do
    GenServer.cast(pid, {:updateMiningReward, reward})
  end
  def get_balance(pid, user_public_key) do
    chain = get_chain(pid)
    balance = Enum.reduce(chain, 0.0, fn(block, acc)->
      acc + Block.get_balance(block, user_public_key)
    end)
    balance
  end

  def process_block_transactions(pid, block_pid) do
    transactions = Block.get_transactions(block_pid)
    IO.inspect("processing all pending transactions.....")
    Enum.each(transactions, fn txn_id ->
      # TODO check if valid transactions
      is_valid = Transaction.verify_transaction(txn_id, Transaction.get_from_address(txn_id))
      if is_valid do
        process_single_transaction(pid, txn_id)
      else
        IO.inspect("Invalid transaction signature does not match, adding it back to the pool of unconfirmed transactions..")
        add_transaction(pid, txn_id)
      end
    end)
  end
  def process_single_transaction(pid, txn_id) do
    from_user = get_user(pid, Transaction.get_from_address(txn_id))
    to_user = get_user(pid, Transaction.get_to_address(txn_id))
    amount = Transaction.get_amount(txn_id)
    User.update_amount(from_user, User.get_amount(from_user) - amount)
    User.update_amount(to_user, User.get_amount(to_user) + amount)
  end
  def update_pending_transcations(pid, transactions) do
    GenServer.cast(pid, {:updatePendingTransactions, transactions})
  end
  def add_user(pid, user_pid) do
    GenServer.cast(pid, {:addUser, user_pid})
  end
  def add_block(pid, block_pid) do
    GenServer.cast(pid, {:addBlock, block_pid})
  end
  def get_pending_transactions(pid) do
    GenServer.call(pid, {:getPendingTransactions})
  end
  def get_user_map(pid) do
    GenServer.call(pid,{:getUserMap})
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
  def get_user(pid, user_public_key) do
    GenServer.call(pid, {:getUser, user_public_key})
  end
  # def is_chain_valid(pid) do
  #   chain = get_chain(pid)
  # end
  def add_transaction(pid, transaction) do
    GenServer.cast(pid, {:addTransaction, transaction})
  end
  def mine_pending_transactions(pid, miningRewardAddress, threshold) do
    {:ok, block_pid} = Block.start_link()
    Block.mine_block(block_pid, threshold)
    latest_block_pid = get_latest_block(pid)
    latest_block_hash = Block.get_hash(latest_block_pid)
    Block.update_previous_hash(block_pid, latest_block_hash)
    add_block(pid, block_pid)
    Block.update_transactions(block_pid, get_pending_transactions(pid))
    Block.recalculate_hash(threshold, block_pid)
    update_pending_transcations(pid, [])
    {:ok, txn_id} = Transaction.start_link("miningReward", miningRewardAddress, get_mining_reward(pid))
    add_transaction(pid, txn_id)
    block_pid
  end
  def is_valid(pid) do
    chain = get_chain(pid)
    index_list = Enum.to_list(1..Enum.count(chain)-1)
    is_valid = Enum.reduce(index_list, true, fn(index, acc) ->
      previous_block = Enum.fetch!(chain, index-1)
      current_block = Enum.fetch!(chain, index)
      hash_is_valid = Block.get_hash(previous_block) == Block.get_previous_hash(current_block)
      acc and hash_is_valid and Block.is_valid(current_block)
    end)
    is_valid
  end
  def create_genesis_block() do
    {:ok, block_pid} = Block.start_link()
    Block.update_previous_hash(block_pid, "")
    Block.update_hash(block_pid, "genesis_block")
    block_pid
  end
  def handle_call({:getPendingTransactions}, _from, state) do
    {_, _, transactions, _, _} = state
    {:reply, transactions, state}
  end
  def handle_call({:getChain}, _from, state) do
    {chain, _, _, _, _} = state
    {:reply, chain, state}
  end
  def handle_call({:getMiningReward}, _from, state) do
    {_, _, _, reward, _} = state
    {:reply, reward, state}
  end
  def handle_call({:getLatestBlock}, _from, state) do
    {chain, _, _, _, _} = state
    latest_block = List.last(chain)
    {:reply, latest_block, state}
  end
  def handle_call({:getUserMap}, _from, state) do
    {_, _, _, _, map} = state
    {:reply, map, state}
  end
  def handle_call({:getUser, user_public_key}, _from, state) do
    {_, _, _, _, map} = state
    user_pid = Map.get(map, user_public_key)
    {:reply, user_pid, state}
  end
  def handle_cast({:addTransaction, transaction}, state) do
    {a, b, transactions, d, e} = state
    state = {a, b, transactions ++ [transaction], d, e}
    {:noreply, state}
  end
  def handle_cast({:updateMiningReward, reward}, state) do
    {a, b, c, _, e} = state
    state = {a, b, c, reward, e}
    {:noreply, state}
  end
  def handle_cast({:updatePendingTransactions, transactions}, state) do
    {a, b, _, d, e} = state
    state = {a, b, transactions, d, e}
    {:noreply, state}
  end
  def handle_cast({:addBlock, block_pid}, state) do
    {chain, b, c, d, e} = state
    state = {chain ++ [block_pid], b, c, d, e}
    {:noreply, state}
  end
  def handle_cast({:addUser, user_pid}, state) do
    {a, b, c, d, map} = state
    user_id = User.get_user_id(user_pid)
    map = Map.put(map, user_id, user_pid)
    state = {a, b, c, d, map}
    {:noreply, state}
  end
end
