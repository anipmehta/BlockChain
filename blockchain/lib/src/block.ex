defmodule Block do

  # def main(threshold) do
  #   threshold = String.to_integer(threshold)
  #   {:ok, pid} = GenServer.start_link(__MODULE__, [])
  #   update_previous_hash(pid, "genesis")
  #   mine_block(pid, threshold)
  # end
  use GenServer
  def init([]) do
    timestamp = :erlang.system_time / 1.0e6 |> round
    {:ok, {"", timestamp, [], 0, ""}}
  end
  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end
  def calculate_hash(string) do
    :crypto.hash(:sha, string) |> Base.encode16
  end
  def mine_block(pid, threshold) do
    previous_hash = get_previous_hash(pid)
    time_stamp = Integer.to_string(get_time_stamp(pid))
    transactions = List.to_string(get_transactions(pid))
    nonce = get_nonce(pid)
    hash = generate_hash(threshold, pid, previous_hash, time_stamp, transactions, nonce)
    IO.puts("Congrats! New Block Mined with hash = " <> hash)
    update_hash(pid, hash)
  end
  def generate_hash(threshold, pid, previous_hash, time_stamp, transactions, nonce) do
    hash = calculate_hash(previous_hash <> time_stamp <> transactions <> Integer.to_string(nonce))
    list = Enum.to_list(1..threshold)
    string_of_zeroes = Enum.reduce(list, "", fn(x, acc) -> "0" <> acc end)
    if String.slice(hash, 0..threshold-1) == string_of_zeroes do
      update_nonce(pid, nonce)
      hash
    else
      generate_hash(threshold, pid, previous_hash, time_stamp, transactions, nonce+1)
    end
  end

  def recalculate_hash(threshold, pid) do
    previous_hash = get_previous_hash(pid)
    time_stamp = Integer.to_string(get_time_stamp(pid))
    transactions = Integer.to_string(Enum.count(get_transactions(pid)))
    nonce = get_nonce(pid)
    hash = Block.generate_hash(threshold, pid, previous_hash, time_stamp, transactions, nonce)
    update_hash(pid, hash)
  end

  def get_balance(pid, user_public_key) do
    transactions = get_transactions(pid)
    balance = Enum.reduce(transactions, 0.0, fn(txn_id, acc)->
      from_address = Transaction.get_from_address(txn_id)
      to_address = Transaction.get_to_address(txn_id)
      amount = Transaction.get_amount(txn_id)
      cond do
        from_address == user_public_key ->
          acc - amount
        to_address == user_public_key ->
          acc + amount
        true ->
          acc
      end
    end)
    balance
  end


  def get_nonce(pid) do
    GenServer.call(pid, {:getNonce})
  end
  def get_hash(pid) do
    GenServer.call(pid, {:getHash})
  end
  def get_transactions(pid) do
    GenServer.call(pid, {:getTransactions})
  end
  def get_previous_hash(pid) do
    GenServer.call(pid, {:getPreviousHash})
  end
  def get_time_stamp(pid) do
    GenServer.call(pid, {:getTimeStamp})
  end
  def update_hash(pid, hash) do
    GenServer.cast(pid, {:updateHash, hash})
  end
  def update_transactions(pid, transactions) do
    GenServer.cast(pid, {:updateTransactions, transactions})
  end
  def update_previous_hash(pid, previous_hash) do
    GenServer.cast(pid, {:updatePreviousHash, previous_hash})
  end
  def update_nonce(pid, nonce) do
    GenServer.cast(pid, {:updateNonce, nonce})
  end

  def get_transactions_amount(pid) do
    txns = Block.get_transactions(pid)
    total_txn_amount = Enum.reduce(txns, 0.0, fn (txn_pid, acc)->
      txn_amount = Transaction.get_amount(txn_pid)
      acc + txn_amount
    end)
    total_txn_amount
  end

  def is_valid(pid, chain_pid) do
    transactions = get_transactions(pid)
    flag = Enum.reduce(transactions, true, fn(txn_id, acc) ->
      if Transaction.get_from_address(txn_id) == "miningReward" do
        true
      else
        acc and Transaction.verify_transaction(txn_id, User.get_public_key(Map.get(Chain.get_user_map(chain_pid), Transaction.get_from_address(txn_id))))
      end
    end)
    flag
  end
  #handlers

  def handle_call({:getNonce}, _from, state) do
    {_, _, _, nonce, _} = state
    {:reply, nonce, state}
  end
  def handle_call({:getHash}, _from, state) do
    {_, _, _, _, hash} = state
    {:reply, hash, state}
  end
  def handle_call({:getPreviousHash}, _from, state) do
    {previous_hash, _, _, _, _} = state
    {:reply, previous_hash, state}
  end
  def handle_call({:getTransactions}, _from, state) do
    {_, _, transcations, _, _} = state
    {:reply, transcations, state}
  end
  def handle_call({:getTimeStamp}, _from, state) do
    {_, timestamp, _, _, _} = state
    {:reply, timestamp, state}
  end
  def handle_cast({:updateHash, hash}, state) do
    {previousHash, timestamp, transactions, nonce, _} = state
    state = {previousHash, timestamp, transactions, nonce, hash}
    {:noreply, state}
  end
  def handle_cast({:updateTransactions, transactions}, state) do
    {a, b, _ , d, e} = state
    state = {a, b, transactions, d, e}
    {:noreply, state}
    end
  def handle_cast({:updatePreviousHash, previous_hash}, state) do
    {_, b, c, d, e} = state
    state = {previous_hash, b, c, d, e}
    {:noreply, state}
  end
  def handle_cast({:updateNonce, nonce}, state) do
    {a, b, c , _, e} = state
    state = {a, b, c, nonce, e}
    {:noreply, state}
  end
end
