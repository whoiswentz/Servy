defmodule Servy.Request do
  defstruct method: "",
            path: "",
            response_body: "",
            body: %{},
            headers: %{},
            status_code: nil

  def full_status(%Servy.Request{status_code: status}) do
    "#{status} #{status_reason(status)}"
  end

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
