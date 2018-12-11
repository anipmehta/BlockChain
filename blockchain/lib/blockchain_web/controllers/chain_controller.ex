defmodule BlockchainWeb.ChainController do
  use BlockchainWeb, :controller
  def index(conn, _params) do
    [{_, chain_pid}] = :ets.lookup(:buckets_registry, "block_chain_reference")
    IO.inspect(Block.get_hash(Chain.get_latest_block(chain_pid)))
    {:ok, user_a_id} = User.start_link()
    Chain.add_user(chain_pid, user_a_id)
    Chain.update_mining_reward(chain_pid, 100.0)
    Chain.mine_pending_transactions(chain_pid, User.get_public_key(user_a_id), 3)
    IO.inspect(Chain.get_pending_transactions(chain_pid))
    Chain.mine_pending_transactions(chain_pid, User.get_public_key(user_a_id), 5)
    IO.puts(User.get_user_id(user_a_id))
    IO.inspect(Chain.get_balance(chain_pid, User.get_public_key(user_a_id)))
    user_map = Chain.get_user_map(chain_pid)
    user_balance_map = Enum.map(user_map, fn ({key, pid}) -> {key, Chain.get_balance(chain_pid, User.get_public_key(pid))} end)
    IO.inspect(user_balance_map)
    render(conn, "index.html", map: user_balance_map)
  end
end
