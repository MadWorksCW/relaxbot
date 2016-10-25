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
  def increment(message_id) do
    GenServer.cast(Relaxbot.ReactionCounter, {:increment, message_id})
  end

  @doc """
  decrements the message_id count if the message_id exists and has a count > 0.
  """
  def decrement(message_id) do
    GenServer.cast(Relaxbot.ReactionCounter, {:decrement, message_id})
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, message_id}, _from, message_ids) do
    {:reply, Map.fetch(message_ids, message_id), message_ids}
  end

  def handle_cast({:increment, message_id}, message_ids) do
    count = case Map.get(message_ids, message_id) do
      nil -> 1
      c -> c + 1
    end
    Relaxbot.Tweeter.notify(message_id, count)
    {:noreply, Map.put(message_ids, message_id, count)}
  end

  def handle_cast({:decrement, message_id}, message_ids) do
    count = case Map.get(message_ids, message_id) do
      nil -> 0
      0 -> 0
      c -> c - 1
    end
    {:noreply, Map.put(message_ids, message_id, count)}
  end

end

