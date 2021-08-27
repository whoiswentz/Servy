defmodule Servy.Handler do

  require Logger

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response_body: "", status_code: nil}
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

  def route(%{method: "GET", path: "/wildthings"} = request) do
    %{request | response_body: "Bears, Lions, Tigers", status_code: 200}
  end

  def route(%{method: "GET", path: "/bears"} = request) do
    %{request | response_body: "Teddy, Smokey, Paddington", status_code: 200}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = request) do
    %{request | response_body: "Bear #{id}", status_code: 200}
  end

  def route(%{method: "DELETE", path: "/bears/" <> _id} = request) do
    %{request | response_body: "Bears must never be deleted"}
  end

  def route(%{method: "GET", path: "/about"} = request) do
    file = 
      Path.join(['..', '..', 'pages'])
      |> Path.expand(__DIR__)
      |> Path.join("about.html")

    case File.read(file) do
      {:ok, content} -> %{request | status_code: 200, response_body: content}
      {:error, :enoent} -> %{request | status_code: 404, response_body: "File not found!"}
      {:error, reason} -> %{request | status_code: 500, response_body: "File error: #{reason}"}
    end
  end

  def route(%{path: path} = request) do
    %{request | response_body: "No #{path} here", status_code: 404}
  end

  def track(%{status_code: 404, path: path} = request) do
    Logger.error("The #{path} is on the loose")
    request
  end

  def track(request), do: request

  def format_response(%{response_body: response_body, status_code: status_code}) do
    """
    HTTP/1.1 #{status_reason(status_code)}
    Content-Type: text/html
    Content-Length: #{String.length(response_body)}

    #{response_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
