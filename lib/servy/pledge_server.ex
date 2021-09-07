defmodule Servy.PledgeServer do
  @process_name :pledge_server

  def start do
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @process_name)
    pid
  end

  # CLIENT INTERFACES

  def create_pledge(name, amount) do
    send(@process_name, {self(), :create_pledge, name, amount})

    receive do
      {:response, id} ->
        id
    end
  end

  def recent_pledge do
    send(@process_name, {self(), :recent_pledges})

    receive do
      {:response, pledges} ->
        pledges
    end
  end

  def total_pledged do
    send(@process_name, {self(), :total_pledged})

    receive do
      {:response, total} ->
        total
    end
  end

  # SERVER INTERFACES

  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent_pledges]
        send(sender, {:response, id})
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        listen_loop(state)

      {sender, :total_pledged} ->
        total = Enum.reduce(state, 0, fn {_name, amount}, acc -> amount + acc end)
        send(sender, {:response, total})
        listen_loop(state)

      _ ->
        listen_loop(state)
    end
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
