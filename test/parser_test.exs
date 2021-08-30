defmodule ParserTest do
  use ExUnit.Case

  alias Servy.Parser

  doctest Parser

  test "parse a list of header fields into map" do
    header_lines = ["Header1: Value1", "Header2: Value2"]

    headers = Parser.parse_headers(header_lines)

    assert headers == %{"Header1" => "Value1", "Header2" => "Value2"}
  end
end
