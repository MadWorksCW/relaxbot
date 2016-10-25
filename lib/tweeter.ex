defmodule Relaxbot.Tweeter do
  use GenServer
  alias Relaxbot.MessageCache
  alias Relaxbot.SlackMessage

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: Relaxbot.Tweeter)
  end

  def notify(message_id, 3) do
    {:ok, message_info} = MessageCache.lookup(message_id)
    tweet = post_tweet(message_info.text)
    handle = Application.get_env(:relaxbot, :twitter_handle)
    url = "https://twitter.com/#{handle}/status/#{tweet.id_str}"
    SlackMessage.send_message("Tweetly dee: #{url}", message_info.channel)
  end

  def notify(_message_id, _), do: :ok

  def post_tweet(text) do
    ExTwitter.update(text)
  end

end
