defmodule Relaxbot.Tweeter do
  use GenServer
  alias Relaxbot.MessageCache

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: Relaxbot.Tweeter)
  end

  def notify(message_id, 3) do
    {:ok, text} = MessageCache.lookup(message_id)
    post_tweet(text)
  end

  def notify(_message_id, _), do: :ok

  defp post_tweet(text) do
    ExTwitter.update(text)
  end

end
