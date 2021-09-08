defmodule Servy.FourOhFourCounter do
  use GenServer

  @name __MODULE__

  def start(initial_state \\ %{}) do
    GenServer.start(__MODULE__, initial_state, name: @name)
  end

  def bump_count(path) do
    GenServer.call(@name, {:bump_count, path})
  end

  def get_counts do
    GenServer.call(@name, :get_counts)
  end

  def get_count(path) do
    GenServer.call(@name, {:get_count, path})
  end

  # SERVER CALLBACKS

  def init(init_args) do
    {:ok, init_args}
  end

  def handle_call({:bump_count, path}, _from, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))

    {:reply, :ok, new_state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_count, path}, _from, state) do
    count = Map.get(state, path, 0)
    {:reply, count, state}
  end
end
