defmodule TreePruning.TreeControllerTest do
  use TreePruning.ConnCase

  @valid_response Path.expand("../mock_data/valid_response.json", __DIR__)
    |> File.read! |> Poison.decode!

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "processes a valid tree", %{conn: conn} do
    conn = get(conn, tree_path(conn, :prune, "valid"), %{"indicator_ids" => ["1", "31", "32"]})
    assert json_response(conn, 200) == @valid_response
  end

  test "gives error on invalid tree", %{conn: conn} do
    conn = get(conn, tree_path(conn, :prune, "invalid"), %{"indicator_ids" => ["1", "31", "32"]})
    assert json_response(conn, 404) 
  end

  test "gives error on upstream failure", %{conn: conn} do
    conn = get(conn, tree_path(conn, :prune, "error"), %{"indicator_ids" => ["1", "31", "32"]})
    assert json_response(conn, 500) 
  end
end
