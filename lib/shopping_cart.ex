defmodule ShoppingCart do
  @moduledoc """
  This module represents a shopping cart in an e-commerce application.
  """

  def start_cart do
    spawn(fn -> listen([]) end)
  end

  defp listen(cart) do
    receive do
      {:add_item, item_name} ->
        new_cart = [item_name | cart]
        IO.puts("Item added to cart: #{item_name}")
        listen(new_cart)

      {:remove_item, item_name} ->
        if item_name in cart do
          new_cart = List.delete(cart, item_name)
          IO.puts("Item removed from cart: #{item_name}")
          listen(new_cart)
        else
          IO.puts("Item not found in cart: #{item_name}")
          listen(cart)
        end

      # new_cart = Enum.filter(cart, &(&1 != item_name))
      # IO.puts("Item removed from cart: #{item_name}")
      # listen(new_cart)

      # {:checkout} ->
      #   IO.puts("Checking out...")
      :show ->
        IO.puts("Current cart items: #{inspect(cart)}")
        listen(cart)
    end
  end
end
