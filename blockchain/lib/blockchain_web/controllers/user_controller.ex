defmodule BlockchainWeb.UserController do
  use BlockchainWeb, :controller

  def get_block_chain_reference() do
    [{_, chain_pid}] = :ets.lookup(:buckets_registry, "block_chain_reference")
    chain_pid
  end

  def index(conn, %{"user" => user}) do
    # TODO: add to things public key and balanceb
    chain_pid = get_block_chain_reference()
    user_pid = Map.get(Chain.get_user_map(chain_pid), user)
    user_balance = Chain.get_balance(chain_pid, user)
    IO.inspect(user_balance)
    public_key = User.get_public_key(user_pid)
    users = Map.keys(Chain.get_user_map(chain_pid))
    IO.inspect(users)
    render(conn, "index.html", user: user, balance: user_balance, users: users)
  end
end
