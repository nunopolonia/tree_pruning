defmodule TreePruning.ErrorView do
  use TreePruning.Web, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "Tree not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
