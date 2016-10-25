defmodule Relaxbot.TweetStore do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: Relaxbot.TweetStore)
  end

  @doc """
  Looks up the pid for `tweet_id` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(tweet_id) do
    GenServer.call(Relaxbot.TweetStore, {:lookup, tweet_id})
  end

  @doc """
  Stores a `data` with a unique id of `tweet_id` it will update
  if the key already exists.
  """
  def store(tweet_id, data) do
    GenServer.cast(Relaxbot.TweetStore, {:store, tweet_id, data})
  end

  @doc """
  Deletes the tweet entry by `tweet_id`.
  """
  def delete(tweet_id) do
    GenServer.cast(Relaxbot.TweetStore, {:delete, tweet_id})
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, _db} = :dets.open_file(Application.get_env(:relaxbot, :tweet_store), [type: :set])
  end

  def handle_call({:lookup, tweet_id}, _from, db) do
    case :dets.lookup(db, tweet_id) do 
      [{_tweet_id, data}|_] -> {:reply, {:ok, data}, db}
      [] -> {:reply, {:error, []}, db}
    end
  end

  def handle_cast({:store, tweet_id, data}, db) do
    :dets.insert(db, {tweet_id, data})
    {:noreply, db}
  end

  def handle_cast({:delete, tweet_id}, db) do
    :dets.delete(db, tweet_id)
    {:noreply, db}
  end

end

