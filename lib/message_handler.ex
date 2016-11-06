#TODO This should be refactored into a slack server and the actual message handler
defmodule Relaxbot.MessageHandler do
  alias Relaxbot.SlackMessage
  alias Relaxbot.ReactionCounter
  alias Relaxbot.MessageCache

  use Slack

  def start_link do
    IO.puts "Starting MessageHandler"
    Slack.Bot.start_link(__MODULE__, [], Application.get_env(:relaxbot, :slack_token))
  end

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
    # send_message("connected", "#tcpi", slack)
  end

  def handle_message(message = %{type: "message"}, slack) do
    IO.puts "MESSAGE"
    IO.inspect message
    MessageCache.add(SlackMessage.unique_id(message), %{text: message.text, channel: message.channel})
    # send_message("message unique_id is #{SlackMessage.unique_id(message)}", message.channel, slack)
  end

  # Ignore messages with subtypes (changed, etc) for now
  def handle_message(message = %{type: "message", subtype: _}, slack), do: :ok

  def handle_message(message = %{type: "reaction_added", reaction: "twitter"}, slack) do
    uid = SlackMessage.unique_id(message.item)
    IO.puts "REACTED to #{uid}"
    IO.inspect message
    # send_message("Nice reaction (#{message.reaction}) to #{uid}", message.item.channel, slack)
    ReactionCounter.increment(uid)
    {:ok}
  end

  def handle_message(message = %{type: "reaction_removed", reaction: "twitter"}, slack) do
    uid = SlackMessage.unique_id(message.item)
    IO.puts "REACTED to #{uid}"
    IO.inspect message
    # send_message("removed reaction (#{message.reaction}) to #{uid}", message.item.channel, slack)
    ReactionCounter.decrement(uid)
    {:ok}
  end

  def handle_message(_,_), do: :ok

  def handle_info({:message, text, channel}, slack) do
    IO.puts "Sending your message, captain!"
    send_message(text, channel, slack)

    {:ok}
  end
  def handle_info(_, _), do: :ok

end
