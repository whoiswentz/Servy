defmodule Servy.PledgeServer do
  @name __MODULE__

  use GenServer

  require Logger

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # CLIENT INTERFACE
  def start_link(_init_args) do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledge do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledged do
    GenServer.call(@name, :total_pledged)
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  # SERVER CALLBACKS

  # Used to initialize the server state
  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call(:total_pledged, _from, %State{pledges: pledges} = state) do
    total = Enum.reduce(pledges, 0, fn {_name, amount}, acc -> amount + acc end)
    {:reply, total, state}
  end

  def handle_call(
        {:create_pledge, name, amount},
        _from,
        %State{pledges: pledges, cache_size: cache_size} = state
      ) do
    {:ok, id} = send_pledge_to_service(name, amount)

    most_recent_pledges = Enum.take(pledges, cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]

    new_state = %State{state | pledges: cached_pledges}

    {:reply, id, new_state}
  end

  def handle_call(:recent_pledges, _from, %State{pledges: pledges} = state) do
    {:reply, pledges, state}
  end

  def handle_cast(:clear, state) do
    new_state = %State{state | pledges: []}
    {:noreply, new_state}
  end

  def handle_cast({:set_cache_size, size}, state) do
    new_state = %State{state | cache_size: size}
    {:noreply, new_state}
  end

  # if unexpected message is sent to the server, handle_info will be called
  def handle_info(_message, state) do
    {:noreply, state}
  end
end

# alias Servy.PledgeServer

# {:ok, pid} = PledgeServer.start()

# IO.inspect(PledgeServer.create_pledge("moe", 10))
# IO.inspect(PledgeServer.create_pledge("lary", 100))
# IO.inspect(PledgeServer.create_pledge("asd", 12))
# IO.inspect(PledgeServer.create_pledge("qwe", 43))
# IO.inspect(PledgeServer.recent_pledge())

# PledgeServer.clear

# IO.inspect(PledgeServer.create_pledge("vbcv", 56))
# IO.inspect(PledgeServer.create_pledge("123", 100))
# IO.inspect(PledgeServer.create_pledge("12", 234))
# IO.inspect(PledgeServer.create_pledge("cv", 5676))

# IO.inspect(PledgeServer.recent_pledge())
# PledgeServer.clear
# PledgeServer.set_cache_size(5)

# IO.inspect(PledgeServer.create_pledge("fgd", 23))
# IO.inspect(PledgeServer.create_pledge("jgh", 1))
# IO.inspect(PledgeServer.create_pledge("iuyu", 567))
# IO.inspect(PledgeServer.create_pledge("bvnv", 43))
# IO.inspect(PledgeServer.create_pledge("nwnm", 234))

# IO.inspect(PledgeServer.recent_pledge())
