defmodule BlockchainWeb.ChainController do
  use BlockchainWeb, :controller

  def get_block_chain_reference() do
    [{_, chain_pid}] = :ets.lookup(:buckets_registry, "block_chain_reference")
    chain_pid
  end

  def index(conn, _params) do
    chain_pid = get_block_chain_reference()
    {:ok, user_a_id} = User.start_link()
    Chain.add_user(chain_pid, user_a_id)
    Chain.update_mining_reward(chain_pid, 100.0)
    IO.inspect(User.get_user_id(user_a_id))
    # Chain.mine_pending_transactions(chain_pid, User.get_user_id(user_a_id), 3)
    pending_transactions = Chain.get_pending_transactions(chain_pid)
    txn_details = Enum.reduce(pending_transactions, [], fn txn_id, acc->
      from = Transaction.get_from_address(txn_id)
      to = Transaction.get_to_address(txn_id)
      amount = Transaction.get_amount(txn_id)
      acc ++ [{from, to, amount}]
    end)
    IO.inspect(txn_details)
    render(conn, "index.html", data: txn_details)
  end
  def graph(conn, _params) do
    chain_pid = get_block_chain_reference()
    # {:ok, user_a_id} = User.start_link()
    # Chain.add_user(chain_pid, user_a_id)
    # Chain.update_mining_reward(chain_pid, 100.0)
    # Chain.mine_pending_transactions(chain_pid, User.get_public_key(user_a_id), 3)
    # IO.inspect(Chain.get_pending_transactions(chain_pid))
    # Chain.mine_pending_transactions(chain_pid, User.get_public_key(user_a_id), 5)
    # IO.puts(User.get_user_id(user_a_id))
    # IO.inspect(Chain.get_balance(chain_pid, User.get_public_key(user_a_id)))
    user_map = Chain.get_user_map(chain_pid)
    user_balance_map = Enum.map(user_map, fn ({key, pid}) -> {key, Chain.get_balance(chain_pid, User.get_user_id(pid))} end)
    render(conn, "user_graph.html", map: user_balance_map)
  end
  def mine_view(conn, _params) do
    render(conn, "mine_block.html")
  end
  def mine(conn, _params) do
    chain_pid = get_block_chain_reference()
    Chain.mine_pending_transactions(chain_pid, Map.get(_params, "user"), 3)
    render(conn, "operation_successful.html", message: "Block Mined Successfully", redirect_url: "/chain")
  end
end
