defmodule Servy.SensorController do
  alias Servy.VideoCam
  alias Servy.Render

  def index(request, _params) do
    task = Task.async(Servy.Tracker, :get_location, ["bigfoot"])

    snapshots =
      ["camera-1", "camera-2", "camera-3"]
      |> Enum.map(&Task.async(VideoCam, :get_snapshot, [&1]))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    Render.render(request, "sensors.eex", snapshots: snapshots, location: where_is_bigfoot)
  end
end
