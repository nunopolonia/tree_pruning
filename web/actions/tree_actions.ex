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
    pruned_themes =
      Enum.map(themes, fn(theme) ->
        traverse_theme(theme, convert_ids_to_ints(ids))
      end)

    Enum.reject(pruned_themes, &is_nil/1)
  end

  def traverse_theme(theme = %{"sub_themes" => sub_themes}, ids) do
    pruned_subthemes =
      Enum.map(sub_themes, fn(subtheme) ->
        traverse_subtheme(subtheme, ids)
      end)

    compact_subthemes = Enum.reject(pruned_subthemes, &is_nil/1)

    unless Enum.empty?(compact_subthemes) do
      Map.put(theme, "sub_themes", compact_subthemes)
    end
  end

  def traverse_subtheme(subtheme = %{"categories" => categories}, ids) do
    pruned_categories =
      Enum.map(categories, fn(category) ->
        traverse_category(category, ids)
      end)

    compact_categories = Enum.reject(pruned_categories, &is_nil/1)

    unless Enum.empty?(compact_categories) do
      Map.put(subtheme, "categories", compact_categories)
    end
  end

  def traverse_category(category = %{"indicators" => indicators}, ids) do
    valid_indicators = prune_indicators(indicators, ids)

    unless Enum.empty?(valid_indicators) do
      Map.put(category, "indicators", valid_indicators)
    end
  end

  defp prune_indicators(list, ids) do
    Enum.reduce(list, [], fn(indicator, acc) ->
      case Enum.member?(ids, indicator["id"]) do
        true -> acc ++ [indicator]
        false -> acc
      end
    end)
  end

  defp convert_ids_to_ints(ids) do
    Enum.map(ids, fn(id) -> String.to_integer(id) end)
  end
end
