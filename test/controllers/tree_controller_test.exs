defmodule TreePruning.TreeControllerTest do
  use TreePruning.ConnCase

  alias TreePruning.Tree

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
end
