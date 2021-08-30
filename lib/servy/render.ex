defmodule Servy.Render do
  @templates_path Path.expand("templates", File.cwd!())

  def render(request, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{request | status_code: 200, response_body: content}
  end
end
