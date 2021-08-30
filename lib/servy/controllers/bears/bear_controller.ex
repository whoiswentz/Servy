defmodule Servy.BearController do
  alias Servy.Wildthings

  alias Servy.Bear
  alias Servy.Render

  def index(request, _params) do
    items =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    Render.render(request, "bears/index.eex", bears: items)
  end

  def show(request, %{"id" => id}) do
    item = Wildthings.get_bear(id)

    Render.render(request, "bears/show.eex", bear: item)
  end

  def create(request, %{"name" => name, "type" => type}) do
    %{request | status_code: 201, response_body: "Bear #{name} with type: #{type} created"}
  end

  def delete(request, _params) do
    %{request | response_body: "Bears must never be deleted"}
  end
end
