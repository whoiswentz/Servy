defmodule Servy.PledgeServer do
  @process_name __MODULE__

  alias Servy.GenericServer

  def start(initial_state \\ []) do
    GenericServer.start(__MODULE__, @process_name, initial_state)
  end

  # CLIENT INTERFACES

  def create_pledge(name, amount) do
    GenericServer.call(@process_name, {:create_pledge, name, amount})
  end

  def recent_pledge do
    GenericServer.call(@process_name, :recent_pledges)
  end

  def total_pledged do
    GenericServer.call(@process_name, :total_pledged)
  end

  def clear do
    GenericServer.cast(@process_name, :clear)
  end

  # SERVER CALLBACKS
  def handle_call(:total_pledged, state) do
    total = Enum.reduce(state, 0, fn {_name, amount}, acc -> amount + acc end)
    {total, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_cast(:clear, _state) do
    []
  end

  # PRIVATE FUNCTIONS
  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServer

# PledgeServer.start()

# IO.inspect(PledgeServer.create_pledge("moe", 10))
# IO.inspect(PledgeServer.create_pledge("lary", 100))
# IO.inspect(PledgeServer.create_pledge("moe", 10))
# IO.inspect(PledgeServer.create_pledge("moe", 10))
# IO.inspect(PledgeServer.create_pledge("moe", 10))

# IO.inspect(PledgeServer.recent_pledge())
