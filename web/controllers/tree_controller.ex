defmodule TreePruning.TreeController do
  use TreePruning.Web, :controller

  @upstream Application.get_env(:tree_pruning, :upstream)

  def prune(conn, params) do
    conn = 
      case HTTPoison.get(@upstream <> params["name"]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          conn
          |> put_status(200)
          |> render("tree.json", tree: process_response_body(body))
        {:ok, %HTTPoison.Response{status_code: 500}} ->
          conn
          |> put_status(404)
          |> json(%{error_code: "404", reason_given: "Resource not found."})
        {:error, %HTTPoison.Error{reason: reason}} ->
          conn
          |> put_status(500)
          |> json(%{error_code: "500", reason_given: "None."})
      end
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end
