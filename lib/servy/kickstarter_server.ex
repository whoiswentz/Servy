defmodule Servy.KickstarterServer do
  use GenServer

  require Logger

  def start_link(_init_args) do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  defp start_server do
    server_pid = spawn_link(Servy, :start, [4000])
    Process.register(server_pid, :http_server)
    server_pid
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()

    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, _reason}, _state) do
    server_pid = start_server()
    {:noreply, server_pid}
  end
end
