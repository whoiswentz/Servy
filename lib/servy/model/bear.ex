defmodule Servy.Bear do
  alias Servy.Bear

  @type id :: Integer.t()
  @type name :: String.t()
  @type type :: String.t()
  @type hibernating :: Boolean.t()
  @type t :: %Servy.Bear{id: id, name: name, type: type, hibernating: hibernating}

  @enforce_keys [:id, :name, :type, :hibernating]
  defstruct [:id, :name, :type, :hibernating]

  @spec order_asc_by_name(Bear.t(), Bear.t()) :: boolean
  def order_asc_by_name(a, b), do: a.name <= b.name
end
