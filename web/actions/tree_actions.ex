defmodule TreePruning.TreeActions do
  @moduledoc """
    Provides functions related to tree traversing
    and pruning.
    Using a depth first search method, each branch is searched
    until its categories, where indicators are matched against
    the selected ids.
    Categories without any valid indicator are removed from
    the "categories" array from the parent subtheme. Once every
    category from that subtheme is analyzed and its array compacted
    to remove nil duplicates, the subtheme is either kept or discarded
    depending on the existence of categories in it's "categories" array.
    This "back propagation" happens at every level of the tree until
    every branch is traversed and pruned.
  """
  def prune(themes, ids) do
    prune_nodes(themes, convert_ids_to_ints(ids), [])
  end

  defp prune_nodes([], _ids, result), do: result
  defp prune_nodes([node | tail], ids, result) do
    updated_node = traverse_node(node, ids)
    
    updated_result =
      case is_nil(updated_node) do
        true -> result
        false -> result ++ [updated_node]
      end

    prune_nodes(tail, ids, updated_result)
  end

  defp traverse_node(node, ids) do
    {key, func} =
      case node do
        %{"sub_themes" => _} -> {"sub_themes", &prune_nodes/3}
        %{"categories" => _} -> {"categories", &prune_nodes/3}
        %{"indicators" => _} -> {"indicators", &prune_leaves/3}
      end

    pruned_nodes = func.(node[key], ids, [])

    unless Enum.empty?(pruned_nodes) do
      Map.put(node, key, pruned_nodes)
    end
  end

  defp prune_leaves([], _ids, result), do: result
  defp prune_leaves([indicator | tail], ids, result) do
    updated_result =
      case Enum.member?(ids, indicator["id"]) do
        true -> result ++ [indicator]
        false -> result
      end

    prune_leaves(tail, ids, updated_result)
  end 

  defp convert_ids_to_ints(ids) do
    Enum.map(ids, fn(id) -> String.to_integer(id) end)
  end
end
