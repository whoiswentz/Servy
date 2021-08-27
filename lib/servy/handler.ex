defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
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

  def route(%{path: path} = request) do
    %{request | response_body: "No #{path} here", status_code: 404}
  end

  def format_response(%{response_body: response_body, status_code: status_code} = _request) do
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
