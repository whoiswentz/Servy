defmodule Servy.Bear do
  defstruct id: nil,
            name: "",
            type: "",
            hibernating: false

  def order_asc_by_name(a, b) do
    a.name <= b.name
  end
end
