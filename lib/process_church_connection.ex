defmodule ProcessChurchConnection do
  @moduledoc """
  This module handles the processing of church connections.
  """

  def start_process(connection_id) do
    spawn(fn -> process_connection(connection_id) end)
  end

  defp process_connection(connection_id) do
    processing_time = :rand.uniform(5_000)
    Process.sleep(processing_time)
    IO.puts("Connection #{connection_id} processed in #{processing_time}ms.")
  end
end
