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
    updated_node = 
      case node do
        %{"sub_themes" => _} -> traverse_theme(node, ids)
        %{"categories" => _} -> traverse_subtheme(node, ids)
        %{"indicators" => _} -> traverse_category(node, ids)
      end
    
    updated_result =
      case is_nil(updated_node) do
        true -> result
        false -> result ++ [updated_node]
      end

    prune_nodes(tail, ids, updated_result)
  end

  defp traverse_theme(theme = %{"sub_themes" => sub_themes}, ids) do
    pruned_subthemes = prune_nodes(sub_themes, ids, [])

    unless Enum.empty?(pruned_subthemes) do
      Map.put(theme, "sub_themes", pruned_subthemes)
    end
  end

  defp traverse_subtheme(subtheme = %{"categories" => categories}, ids) do
    pruned_categories = prune_nodes(categories, ids, [])

    unless Enum.empty?(pruned_categories) do
      Map.put(subtheme, "categories", pruned_categories)
    end
  end

  defp traverse_category(category = %{"indicators" => indicators}, ids) do
    valid_indicators = prune_leafs(indicators, ids, [])

    unless Enum.empty?(valid_indicators) do
      Map.put(category, "indicators", valid_indicators)
    end
  end

  defp prune_leafs([], _ids, result), do: result
  defp prune_leafs([indicator | tail], ids, result) do
    updated_result =
      case Enum.member?(ids, indicator["id"]) do
        true -> result ++ [indicator]
        false -> result
      end

    prune_leafs(tail, ids, updated_result)
  end 

  defp convert_ids_to_ints(ids) do
    Enum.map(ids, fn(id) -> String.to_integer(id) end)
  end
end
