defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  alias Servy.GenericServer

  def start(initial_state \\ %{}) do
    GenericServer.start(__MODULE__, @name, initial_state)
  end

  def bump_count(path) do
    GenericServer.call(@name, {:bump_count, path})
  end

  def get_counts do
    GenericServer.call(@name, :get_counts)
  end

  def get_count(path) do
    GenericServer.call(@name, {:get_count, path})
  end

  # SERVER CALLBACKS
  def handle_call({:bump_count, path}, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))

    {:ok, new_state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_call({:get_count, path}, state) do
    count = Map.get(state, path, 0)
    {count, state}
  end
end
