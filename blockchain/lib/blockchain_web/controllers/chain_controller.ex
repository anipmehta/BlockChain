defmodule BlockchainWeb.ChainController do
  use BlockchainWeb, :controller
  def index(conn, _params) do
    [{_, chain_pid}] = :ets.lookup(:buckets_registry, "block_chain_reference")
    IO.inspect(Block.get_hash(Chain.get_latest_block(chain_pid)))
    {:ok, user_a_id} = User.start_link()
    Chain.add_user(chain_pid, user_a_id)
    IO.inspect(User.get_user_id(user_a_id))
    render(conn, "index.html")
  end
end
