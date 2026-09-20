defmodule ProcessChurchConnection do
  @moduledoc """
  This module handles the processing of church connections.
  """

  def start_process do
    spawn(fn -> process_connection() end)
  end

  defp process_connection do
    Process.sleep(10_000)
    IO.puts("Connection processed.")
  end
end
