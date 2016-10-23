defmodule Relaxbot.MessageCache do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: Relaxbot.MessageCache)
  end

  @doc """
  Looks up the pid for `message_id` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(message_id) do
    GenServer.call(Relaxbot.MessageCache, {:lookup, message_id})
  end

  @doc """
  Adds a message if message_id is not present, updates it if message_id exists
  """
  def add(message_id, message) do
    GenServer.cast(Relaxbot.MessageCache, {:add, message_id, message})
  end

  @doc """
  removes the message_id count if the message_id exists
  """
  def remove(message_id) do
    GenServer.cast(Relaxbot.MessageCache, {:remove, message_id})
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, message_id}, _from, message_ids) do
    {:reply, Map.fetch(message_ids, message_id), message_ids}
  end

  def handle_cast({:add, message_id, message}, message_ids) do
    {:noreply, Map.put(message_ids, message_id, message)}
  end

  def handle_cast({:remove, message_id}, message_ids) do
    {:noreply, Map.delete(message_ids, message_id)}
  end

end

