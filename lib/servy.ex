defmodule Servy do
  use Application

  require Logger

  def start(_type, _args) do
    Logger.info("Starting the #{__MODULE__} application")
    Servy.ApplicationSupervisor.start_link
  end
end
