defmodule BlockchainWeb.TransactionController do
  use BlockchainWeb, :controller

  def get_block_chain_reference() do
    [{_, chain_pid}] = :ets.lookup(:buckets_registry, "block_chain_reference")
    chain_pid
  end

  def create(conn, _params) do
    chain_pid = get_block_chain_reference()
    IO.inspect(_params)
    from = Map.get(_params, "from")
    to = Map.get(_params, "to")
    amount = String.to_float(Map.get(_params, "amount"))
    {:ok, txn_id} = Transaction.start_link(from, to, amount)
    IO.inspect(txn_id)
    from_pid = Map.get(Chain.get_user_map(chain_pid), from)
    User.sign_transaction(from_pid, txn_id)
    Chain.add_transaction(chain_pid, txn_id)
    render(conn, "operation_successful.html", message: "Transaction was successfully created and signed by User:" <> from, redirect_url: "/chain")
  end
end
