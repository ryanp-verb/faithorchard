defmodule ProcessSpawner do
  @moduledoc """
  This module is responsible for spawning processes.
  """

  def spawn_processes(number_of_processes) do
    1..number_of_processes
    |> Enum.each(fn id ->
      ProcessChurchConnection.start_process(id)
    end)
  end
end
