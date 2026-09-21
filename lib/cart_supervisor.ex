defmodule CartSupervisor do
  use Supervisor

  def init(_init_arg) do
    children = [
      CartServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
