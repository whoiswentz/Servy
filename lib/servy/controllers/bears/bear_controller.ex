defmodule Servy.BearController do
  alias Servy.Wildthings

  alias Servy.Bear

  def index(request, _params) do
    items =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(fn i -> "<li>#{i.name} - #{i.type}</li>" end)
      |> Enum.join()

    %{request | status_code: 200, response_body: "<ul>#{items}</ul>"}
  end

  def show(request, %{"id" => id}) do
    item = Wildthings.get_bear(id)

    %{request | response_body: "<h1>Bear #{item.id}</h1>", status_code: 200}
  end

  def create(request, %{"name" => name, "type" => type}) do
    %{request | status_code: 201, response_body: "Bear #{name} with type: #{type} created"}
  end

  def delete(request, _params) do
    %{request | response_body: "Bears must never be deleted"}
  end
end
