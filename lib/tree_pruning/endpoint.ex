defmodule TreePruning.Endpoint do
  use Phoenix.Endpoint, otp_app: :tree_pruning

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug TreePruning.Router
end
