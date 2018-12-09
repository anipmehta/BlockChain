defmodule BlockchainWeb.UserController do
  use BlockchainWeb, :controller

  def index(conn, %{"user" => user}) do
    BlockChain.main("3")
    render(conn, "index.html", user: user)
  end
end
