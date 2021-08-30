defmodule Servy.Plugins do
  require Logger

  def rewrite_path(%{path: "/wildlife"} = request) do
    %{request | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = request) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    matches = Regex.named_captures(regex, path)
    rewrite_path_captures(request, matches)
  end

  def rewrite_path_captures(request, %{"thing" => thing, "id" => id}) do
    %{request | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(request, nil), do: request

  def log(request), do: IO.inspect(request)

  def track(%{status_code: 404, path: path} = request) do
    Logger.error("The #{path} is on the loose")
    request
  end

  def track(request), do: request
end
