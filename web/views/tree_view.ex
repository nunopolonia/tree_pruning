defmodule TreePruning.TreeView do
  use TreePruning.Web, :view

  def render("tree.json", %{tree: tree}) do
    tree
  end
end
