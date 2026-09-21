defmodule CartServer do
  use GenServer

  # client-facing
  def start_link do
    GenServer.start_link(CartServer, %{}, name: :cart_server)
  end

  def cart_total, do: GenServer.call(:cart_server, :total)

  def add_item(item), do: GenServer.cast(:cart_server, {:add_item, item})

  def get_cart, do: GenServer.call(:cart_server, :get_cart)

  # callbacks
  @impl true
  def init(_state) do
    {:ok, %{cart: [], timer_pid: nil}}
  end

  @impl true
  def handle_call(action, _from, state) do
    case action do
      :total ->
        total =
          state.cart
          |> Enum.reduce(0, fn item, acc -> acc + item[:price] * item[:quantity] end)

        {:reply, total, state}

      :get_cart ->
        cart = state.cart
        {:reply, cart, state}
    end
  end

  @impl true
  def handle_cast({:add_item, item}, state) do
    # 10 seconds for demonstration purposes

    new_state =
      %{state | cart: [item | state.cart]}
      |> reminder_timer()

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:reminder, state) do
    IO.puts("Don't forget to check out your cart!")
    {:noreply, state}
  end

  defp reminder_timer(state) do
    case state[:timer_pid] do
      nil ->
        %{state | timer_pid: Process.send_after(self(), :reminder, 10_000)}

      _ ->
        Process.cancel_timer(state[:timer_pid])
        %{state | timer_pid: Process.send_after(self(), :reminder, 10_000)}
    end
  end
end
