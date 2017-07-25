defmodule TreePruning.TreeController do
  use TreePruning.Web, :controller

  alias TreePruning.{ErrorView, TreeActions}

  @http_lib Application.get_env(:tree_pruning, :http_lib)
  @upstream Application.get_env(:tree_pruning, :upstream)

  def prune(conn, %{"name" => _}) do
    conn
    |> put_status(200)
    |> render("tree.json", tree: [])
  end
  def prune(conn, %{"name" => name, "indicator_ids" => ids}) do
    case @http_lib.get(@upstream <> name) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        tree = TreeActions.prune(process_response_body(body), ids)

        conn
        |> put_status(200)
        |> render("tree.json", tree: tree)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json")
      {:ok, %HTTPoison.Response{status_code: 500}} ->
        conn
        |> put_status(500)
        |> render(ErrorView, "500.json")
      end
  end

  defp process_response_body(body) do
    body
    |> Poison.decode!
  end
end
