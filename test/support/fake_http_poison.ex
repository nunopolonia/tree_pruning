defmodule FakeHTTPoison do
  @upstream Application.get_env(:tree_pruning, :upstream)
  @valid_upstream_response Path.expand("../mock_data/valid_upstream_response.json", __DIR__)
    |> File.read!

  def get(url) do
    name = String.trim(url, @upstream)

    case name do
      "valid" -> { :ok, successful_response }
      "invalid" -> { :ok, not_found_response }
      "error" -> { :ok, error_response }
    end
  end

  defp successful_response do
    %HTTPoison.Response{
      headers: [{"Content-Type", "application/json"}],
      status_code: 200,
      body: @valid_upstream_response
    }
  end

  defp not_found_response do
    %HTTPoison.Response{
      headers: [{"Content-Type", "application/json"}],
      status_code: 404,
      body: "potato"
    }
  end

  defp error_response do
    %HTTPoison.Response{
      headers: [{"Content-Type", "application/json"}],
      status_code: 500,
      body: "potato"
    }
  end
end