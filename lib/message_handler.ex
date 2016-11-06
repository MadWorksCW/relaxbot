#TODO This should be refactored into a slack server and the actual message handler
defmodule Relaxbot.MessageHandler do
  alias Relaxbot.SlackMessage
  alias Relaxbot.ReactionCounter
  alias Relaxbot.MessageCache

  use Slack

  def start_link do
    IO.puts "Starting MessageHandler"
    {:ok, pid} = Slack.Bot.start_link(__MODULE__, [], Application.get_env(:relaxbot, :slack_token), %{name: __MODULE__})
    {:ok, pid}
  end

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    # send_message("connected", "#tcpi", slack)
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, _slack, state) do
    IO.puts "MESSAGE"
    IO.inspect message
    MessageCache.add(SlackMessage.unique_id(message), %{text: message.text, channel: message.channel})
    # send_message("message unique_id is #{SlackMessage.unique_id(message)}", message.channel, slack)
    {:ok, state}
  end

  # Ignore messages with subtypes (changed, etc) for now
  def handle_event(%{type: "message", subtype: _}, _slack, state), do: {:ok, state}

  def handle_event(message = %{type: "reaction_added", reaction: "twitter"}, _slack, state) do
    uid = SlackMessage.unique_id(message.item)
    IO.puts "REACTED to #{uid}"
    IO.inspect message
    # send_message("Nice reaction (#{message.reaction}) to #{uid}", message.item.channel, slack)
    ReactionCounter.increment(uid)
    {:ok, state}
  end

  def handle_event(message = %{type: "reaction_removed", reaction: "twitter"}, _slack, state) do
    uid = SlackMessage.unique_id(message.item)
    IO.puts "REACTED to #{uid}"
    IO.inspect message
    # send_message("removed reaction (#{message.reaction}) to #{uid}", message.item.channel, slack)
    ReactionCounter.decrement(uid)
    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"
    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

end
