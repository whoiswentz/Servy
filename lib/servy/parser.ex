defmodule Servy.Parser do
  alias Servy.Request

  def parse(request) do
    [request_info, body] = String.split(request, "\n\n")
    decoded_body = body |> String.trim() |> URI.decode_query()
    [start_line | headers] = String.split(request_info, "\n")
    [method, path, _] = start_line |> String.split(" ")

    %Request{
      method: method,
      path: path,
      body: decoded_body
    }
  end
end
