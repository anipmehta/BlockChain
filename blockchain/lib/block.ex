defmodule Block do
  use GenServer
  def init() do
    timestamp = :erlang.system_time / 1.0e6 |> round
    {:ok, {"", timestamp, [], 0, ""}}
  end
  def calculate_hash(string) do
    :crypto.hash(:sha, string) |> Base.encode16
  end
  def mine_block(pid, threshold) do
    previous_hash = get_previous_hash(pid)
    time_stamp = get_time_stamp(pid)
    transactions = List.to_string(get_transactions(pid))
    nonce = get_nonce(pid)
    hash = generate_hash(threshold, pid, previous_hash <> time_stamp <> transactions <> nonce)
  end
  def generate_hash(threshold, pid, previous_hash, time_stamp, transactions, nonce) do
    hash = calculate_hash(previous_hash <> time_stamp <> transactions <> Integer.to_string(nonce))
    string_of_zeroes = Enum.join(0...threshold-1, "0")
    if String.slice(hash, 0...threshold-1) == string_of_zeroes
      IO.puts('New Block Mined.......')
      update_nonce(pid, nonce)
      hash
    generate_hash(threshold, pid, previous_hash, time_stamp, transactions, nonce+1)
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
  def handle_call({:getTranscations}, _from, state) do
    {_, _, _, transcations, _} = state
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
