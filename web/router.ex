defmodule TreePruning.Router do
  use TreePruning.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TreePruning do
    pipe_through :api

    get "/tree/:name", TreeController, :prune
  end
end
