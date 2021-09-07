defmodule Servy.PledgeController do
  alias Servy.PledgeServer

  def create(request, %{"name" => name, "amount" => amount}) do
    PledgeServer.create_pledge(name, amount)

    %{request | status_code: 201, response_body: "#{name} pledged #{amount}"}
  end

  def index(request) do
    pledges = PledgeServer.recent_pledge()

    %{request | status_code: 200, response_body: inspect(pledges)}
  end
end
