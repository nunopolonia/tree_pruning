defmodule TreePruning.Endpoint do
  use Phoenix.Endpoint, otp_app: :tree_pruning

  plug Plug.RequestId
  plug Plug.Logger

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug TreePruning.Router
end
