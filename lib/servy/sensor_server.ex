defmodule Servy.SensorServer do
  use GenServer

  require Logger

  alias Servy.VideoCam
  alias Servy.Tracker

  @name __MODULE__

  def start_link(_init_args) do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start(__MODULE__, %{}, name: @name)
  end

  def get_sensors_data do
    GenServer.call(@name, :get_sensors_data)
  end

  def run_tasks_to_get_sensor_data do
    task = Task.async(Tracker, :get_location, ["bigfoot"])

    snapshots =
      ["camera-1", "camera-2", "camera-3"]
      |> Enum.map(&Task.async(VideoCam, :get_snapshot, [&1]))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, where_is_bigfoot: where_is_bigfoot}
  end

  def init(_init_state) do
    init_state = run_tasks_to_get_sensor_data()
    Process.send_after(self(), :refresh, :timer.minutes(10))
    {:ok, init_state}
  end

  def handle_call(:get_sensors_data, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:refresh, _state) do
    Logger.info("refreshing the sensor data")
    new_state = run_tasks_to_get_sensor_data()
    Process.send_after(self(), :refresh, :timer.minutes(10))
    {:noreply, new_state}
  end
end
