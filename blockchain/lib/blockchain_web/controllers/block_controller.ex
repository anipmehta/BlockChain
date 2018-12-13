defmodule BlockchainWeb.BlockController do
  use BlockchainWeb, :controller

  def get_block_chain_reference() do
    [{_, chain_pid}] = :ets.lookup(:buckets_registry, "block_chain_reference")
    chain_pid
  end

  def create(conn, _params) do

  end

  def index(conn,  %{"hash" => hash}) do
    chain_pid = get_block_chain_reference()
    blocks = Chain.get_chain(chain_pid)
    IO.inspect(blocks)
    IO.inspect(hash)
    block_pid = Enum.reduce(blocks, None, fn(pid, acc)->
      block_hash = Block.get_hash(pid)
      IO.inspect(block_hash)
      IO.inspect(hash)
      IO.inspect(block_hash==hash)
      if block_hash == hash do pid else acc end
    end)
    block_transactions = Block.get_transactions(block_pid)
    txn_details = Enum.reduce(block_transactions, [], fn txn_id, acc->
      from = Transaction.get_from_address(txn_id)
      to = Transaction.get_to_address(txn_id)
      amount = Transaction.get_amount(txn_id)
      IO.inspect(from)
      acc ++ [{from, to, amount}]
    end)
    block_txns_amount = Block.get_transactions_amount(block_pid)
    IO.inspect(txn_details)
    render(conn, "index.html", hash: hash, total_amount: block_txns_amount,transactions: txn_details)
  end
end
