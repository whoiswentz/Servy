defmodule Servy.VideoCam do
  def get_snapshot(camera_name) do
    :timer.sleep(1_000)

    "#{camera_name}-snapshot.jpg"
  end
end
