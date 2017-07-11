defmodule TreePruning.Router do
  use TreePruning.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TreePruning do
    pipe_through :api
  end
end
