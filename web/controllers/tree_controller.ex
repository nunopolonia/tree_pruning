defmodule TreePruning.TreeController do
  use TreePruning.Web, :controller

  alias TreePruning.{ErrorView, TreeActions}

  @http_lib Application.get_env(:tree_pruning, :http_lib)
  @upstream Application.get_env(:tree_pruning, :upstream)
  @upstream_tries Application.get_env(:tree_pruning, :upstream_tries)

  def prune(conn, %{"name" => name, "indicator_ids" => ids}) do
    try do
      for n <- 1..@upstream_tries do
        case @http_lib.get(@upstream <> name) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            throw {:ok, body: body}
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            throw {:ok, status_code: 404}
          {:ok, %HTTPoison.Response{status_code: 500}} -> :timer.sleep(100)

        end
      end

      conn
      |> put_status(500)
      |> render(ErrorView, "500.json")
    catch
      {:ok, body: body} ->
        tree = TreeActions.prune(process_response_body(body), ids)

        conn
        |> put_status(200)
        |> render("tree.json", tree: tree)
      {:ok, status_code: 404} ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json")
    end
  end

  def prune(conn, %{"name" => _}) do
    conn
    |> put_status(200)
    |> render("tree.json", tree: [])
  end

  defp process_response_body(body) do
    body
    |> Poison.decode!
  end
end
