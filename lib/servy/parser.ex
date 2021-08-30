defmodule Servy.Parser do
  alias Servy.Request

  def parse(request) do
    [request_info, body] = String.split(request, "\n\n")
    [start_line | headers] = String.split(request_info, "\n")
    [method, path, _] = start_line |> String.split(" ")

    parsed_headers = parse_headers(headers)
    decoded_body = parse_body(parsed_headers["Content-Type"], body)

    %Request{
      method: method,
      path: path,
      body: decoded_body,
      headers: parsed_headers
    }
  end

  defp parse_body("application/x-www-form-urlencoded", body) do
    body |> String.trim() |> URI.decode_query()
  end

  defp parse_body(_, _), do: %{}

  def parse_headers(string_header) do
    Enum.reduce(string_header, %{}, fn header, headers_map ->
      [key, value] = String.split(header, ": ")
      Map.put(headers_map, key, value)
    end)
  end
end
