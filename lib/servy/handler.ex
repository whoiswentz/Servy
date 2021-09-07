defmodule Servy.Handler do
  require Logger

  alias Servy.Request

  alias Servy.Api

  alias Servy.BearController
  alias Servy.SensorController
  alias Servy.PledgeController

  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]

  @pages_path Path.expand('pages', File.cwd!())

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Request{method: "GET", path: "404s"} = request) do
    counts = Servy.FourOhFourCounter.get_counts()

    %{request | status_code: 200, response_body: inspect(counts)}
  end

  def route(%Request{method: "GET", path: "/pledges"} = request) do
    PledgeController.index(request)
  end

  def route(%Request{method: "POST", path: "/pledges", body: body} = request) do
    PledgeController.create(request, body)
  end

  def route(%Request{method: "GET", path: "/sensors"} = request) do
    SensorController.index(request, request.params)
  end

  def route(%Request{method: "GET", path: "/wildthings"} = request) do
    %{request | response_body: "Bears, Lions, Tigers", status_code: 200}
  end

  def route(%Request{method: "GET", path: "/bears"} = request) do
    BearController.index(request, request.params)
  end

  def route(%Request{method: "GET", path: "/api/bears"} = request) do
    Api.BearController.index(request, request.params)
  end

  def route(%Request{method: "POST", body: body, path: "/bears"} = request) do
    BearController.create(request, body)
  end

  def route(%Request{method: "GET", params: params, path: "/bears/" <> id} = request) do
    requet_params = Map.put(params, "id", id)
    BearController.show(request, requet_params)
  end

  def route(%Request{method: "DELETE", path: "/bears/" <> _id} = request) do
    BearController.delete(request, request.params)
  end

  def route(%Request{method: "GET", path: "/pages/" <> page} = request) do
    file =
      @pages_path
      |> Path.expand(__DIR__)
      |> Path.join(page <> ".html")

    Logger.info("Serving request to page #{file}")

    # We can use multi clause function here, but for learning I won't
    case File.read(file) do
      {:ok, content} ->
        %{request | status_code: 200, response_body: content}

      {:error, :enoent} ->
        %{request | status_code: 404, response_body: "File not found!"}

      {:error, reason} ->
        %{request | status_code: 500, response_body: "File error: #{reason}"}
    end
  end

  def route(%Request{path: path} = request) do
    Servy.FourOhFourCounter.bump_count(path)
    %{request | response_body: "No #{path} here", status_code: 404}
  end

  def format_response(%Request{headers: headers, response_body: response_body} = request) do
    """
    HTTP/1.1 #{Request.full_status(request)}\r
    Content-Type: #{headers["Content-Type"]}\r
    Content-Length: #{String.length(response_body)}\r
    \r
    #{response_body}
    """
  end
end
