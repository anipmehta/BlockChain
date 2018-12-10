defmodule BlockchainWeb.UserController do
  use BlockchainWeb, :controller

  def get_block_chain_referecne() do
    [{_, chain_pid}] = :ets.lookup(:buckets_registry, "block_chain_reference")
    chain_pid
  end

  def index(conn, %{"user" => user}) do
    # TODO: add to things public key and balanceb
    chain_pid = get_block_chain_referecne()
    user_pid = Map.get(Chain.get_user_map(chain_pid), user)
    user_balance = Chain.get_balance(chain_pid, user_pid)
    IO.inspect(user_balance)
    public_key = User.get_public_key(user_pid)
    render(conn, "index.html", user: user, balance: user_balance)
  end
end
