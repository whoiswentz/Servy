defmodule Servy.Parser do
  alias Servy.Request

  @spec parse(String.t()) :: Request.t()
  def parse(request) do
    [request_info, body] = String.split(request, "\r\n\r\n")
    [start_line | headers] = String.split(request_info, "\r\n")
    [method, path, _] = start_line |> String.split(" ")

    parsed_headers = parse_headers(headers)
    decoded_body = parse_params(parsed_headers["Content-Type"], body)

    %Request{
      method: method,
      path: path,
      body: decoded_body,
      headers: parsed_headers
    }
  end

  @doc """
  Parse the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values.

  ## Example
    iex> params_string = "key1=value1&key2=value2"
    iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
    %{"key1" => "value1", "key2" => "value2"}
    iex> Servy.Parser.parse_params("invalid/type", params_string)
    %{}
  """
  def parse_params("application/x-www-form-urlencoded", params) do
    params |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}

  def parse_headers(string_header) do
    Enum.reduce(string_header, %{}, fn header, headers_map ->
      [key, value] = String.split(header, ": ")
      Map.put(headers_map, key, value)
    end)
  end
end
