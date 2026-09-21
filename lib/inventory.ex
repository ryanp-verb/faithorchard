defmodule Inventory do
  def check_inventory(item_id) do
    :timer.sleep(5000)
    {:ok, "Inventory checked for item #{item_id}"}
  end
end
