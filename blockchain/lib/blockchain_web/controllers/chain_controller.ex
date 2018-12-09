defmodule BlockchainWeb.ChainController do
  use BlockchainWeb, :controller
  def index(conn, _params) do
    Chain.main("3")
    render(conn, "index.html")
  end
end
