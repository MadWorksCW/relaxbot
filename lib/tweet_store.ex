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
  Has this messages been tweeted already?

  Returns `true if the tweet has been
  """
  def tweeted?(message_id) do
    GenServer.call(__MODULE__, {:tweeted?, message_id})
  end

  @doc """
  Notify the store that this message has been tweeted

  Returns `true if the tweet has been
  """
  def tweet(message_id) do
    GenServer.cast(__MODULE__, {:tweet, message_id})
  end

  ## Server Callbacks
  def init(:ok) do
    case open_dets do
      {:ok, db} -> {:ok, db}
      {:EXIT, _} -> open_dets(:clean)
    end
  end

  defp open_dets do
    :dets.open_file(
      Application.get_env(:relaxbot, :tweet_store),
      [type: :set, auto_save: 10000]
    )
  end

  defp open_dets(:clean) do
    IO.puts("Dets file corrupt, recreating...")
    File.rm Application.get_env(:relaxbot, :tweet_store)
    open_dets
  end

  def handle_call({:tweeted?, id}, _from, db) do
    case :dets.lookup(db, id) do
      [{_id, _data}|_] -> {:reply, true, db}
      [] -> {:reply, false, db}
    end
  end

  def handle_cast({:tweet, id}, db) do
    :dets.insert(db, {id, true})
    {:noreply, db}
  end

end

