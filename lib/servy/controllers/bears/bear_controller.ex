defmodule Servy.BearController do
  alias Servy.Wildthings

  def index(request) do
    bears = Wildthings.list_bears()

    # TODO: Generate a list of bears
    %{request | status_code: 200, response_body: "<ul>NAMEs</ul>"}
  end

  def show(request, %{"id" => id}) do
    %{request | response_body: "Bear #{id}", status_code: 200}
  end

  def create(request, %{"name" => name, "type" => type}) do
    %{request | status_code: 201, response_body: "Bear #{name} with type: #{type} created"}
  end
end
