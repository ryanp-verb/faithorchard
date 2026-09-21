defmodule CartServer do
  use GenServer

  # client-facing
  def start_link(name) do
    IO.puts("Cart Server starting...")
    GenServer.start_link(CartServer, %{}, name: name)
  end

  def start_child(name) when is_atom(name) do
    IO.puts("Cart Server #{name} starting...")
    DynamicSupervisor.start_child(:dynamic_cart_supervisor, {CartServer, name})
  end

  def cart_total(cart_id) when is_atom(cart_id), do: GenServer.call(cart_id, :total)

  def add_item(cart_id, item) when is_atom(cart_id),
    do: GenServer.cast(cart_id, {:add_item, item})

  def get_cart(cart_id) when is_atom(cart_id), do: GenServer.call(cart_id, :get_cart)

  # callbacks
  def child_spec(name) do
    %{
      id: __MODULE__,
      restart: :permanent,
      shutdown: 5000,
      start: {__MODULE__, :start_link, [name]},
      type: :worker
    }
  end

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
