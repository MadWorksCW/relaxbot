defmodule Relaxbot.ReactionCounter do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: Relaxbot.ReactionCounter)
  end

  @doc """
  Looks up the pid for `message_id` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(message_id) do
    GenServer.call(Relaxbot.ReactionCounter, {:lookup, message_id})
  end

  @doc """
  Adds a message_id if it doesn't exist, increments the reaction count if it does.
  """
  def add(message_id) do
    GenServer.cast(Relaxbot.ReactionCounter, {:add, message_id})
  end

  @doc """
  decrements the message_id count if the message_id exists and has a count > 0.
  """
  def remove(message_id) do
    GenServer.cast(Relaxbot.ReactionCounter, {:remove, message_id})
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, message_id}, _from, message_ids) do
    {:reply, Map.fetch(message_ids, message_id), message_ids}
  end

  def handle_cast({:add, message_id}, message_ids) do
    if Map.has_key?(message_ids, message_id) do
    	message_ids = Map.put(message_ids, message_id, Map.get(message_ids, message_id) + 1)
      {:noreply, message_ids}
    else
      {:noreply, Map.put(message_ids, message_id, 1)}
    end
  end

  def handle_cast({:remove, message_id}, message_ids) do
    if Map.has_key?(message_ids, message_id) do
    	tweet_count = Map.get(message_ids, message_id)
    	if ( tweet_count > 0 ) do
    		{:noreply, Map.put(message_ids, message_id, tweet_count - 1)}
    	else
    		{:noreply, message_ids}
    	end
    else
    	# pass through, shouldn't remove if if doesn't have a key
      {:noreply, message_ids}
    end
  end

end

