defmodule Servy.ApplicationSupervisor do
  use Supervisor

  require Logger

  def start_link do
    Logger.info("Starting #{__MODULE__}")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    childrens = [
      Servy.KickstarterServer,
      Servy.ServicesSupervisor
    ]

    Supervisor.init(childrens, strategy: :one_for_one)
  end
end
