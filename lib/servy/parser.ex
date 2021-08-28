defmodule Servy.Parser do
  alias Servy.Request

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Request{
      method: method,
      path: path,
      response_body: "",
      status_code: nil
    }
  end
end
