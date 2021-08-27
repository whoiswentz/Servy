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

    %{method: method, path: path, response_body: ""}
  end

  def log(request), do: IO.inspect(request)

  def route(%{method: "GET", path: "/wildthings"} = request) do
    %{request | response_body: "Bears, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = request) do
    %{request | response_body: "Teddy, Smokey, Paddington"}
  end

  def format_response(%{response_body: response_body} = _request) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(response_body)}

    #{response_body}
    """
  end
end
