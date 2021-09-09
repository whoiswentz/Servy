defmodule Servy.ServicesSupervisor do
  use Supervisor

  require Logger

  def start_link(_init_args) do
    Logger.info("Starting #{__MODULE__}")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    childrens = [
      Servy.PledgeServer,
      Servy.SensorServer,
      Servy.FourOhFourCounter
    ]

    Supervisor.init(childrens, strategy: :one_for_one)
  end
end
