defmodule BlockchainWeb.Router do
  use BlockchainWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlockchainWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/transactions", TransactionsController
    get "/user/:user", UserController, :index
    get "/chain", ChainController, :index
    get "/chain/users/graph", ChainController, :graph
    get "/chain/users/table", ChainController, :table
    get "/chain/block/mine", ChainController, :mine_view
    get "/chain/blocks", ChainController, :view_blocks
    post "/chain/block/mine", ChainController, :mine
    post "/chain/transaction/create", TransactionController, :create
    get "/block/:hash", BlockController, :index
    post "chain/user/create", ChainController, :create_user
    get "/chain/blocks/graph", ChainController, :show_block_graph
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlockchainWeb do
  #   pipe_through :api
  # end
end
