defmodule VisitorTracker do
  use Agent

  def start_link(_arg) do
    IO.puts("Visitor Tracker starting...")
    Agent.start_link(fn -> %{} end, name: :visitor_tracker)
  end

  def add(item_id) do
    Agent.update(:visitor_tracker, fn counts ->
      Map.update(counts, item_id, 1, &(&1 + 1))
    end)
  end

  def remove(item_id) do
    Agent.update(:visitor_tracker, fn counts ->
      Map.update(counts, item_id, 0, &(&1 - 1))
    end)
  end

  def get_count(item_id) do
    Agent.get(:visitor_tracker, fn counts ->
      Map.get(counts, item_id, 0)
    end)
  end
end
