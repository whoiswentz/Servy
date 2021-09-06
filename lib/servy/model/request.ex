defmodule Servy.Request do
  alias Servy.Request

  @type method :: String.t()
  @type path :: String.t()
  @type response_body :: String.t()
  @type body :: Map.t()
  @type params :: Map.t()
  @type headers :: Map.t()
  @type status_code :: Integer.t()

  @type t :: %Request{
          method: method,
          path: path,
          response_body: response_body,
          body: body,
          params: params,
          headers: headers,
          status_code: status_code
        }

  @enforce_keys [:method, :path]
  defstruct [:method, :path, :response_body, :body, :params, :headers, :status_code]

  @spec full_status(Request.t()) :: String.t()
  def full_status(%Servy.Request{status_code: status}) do
    "#{status} #{status_reason(status)}"
  end

  @spec status_reason(Integer.t()) :: String.t()
  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
