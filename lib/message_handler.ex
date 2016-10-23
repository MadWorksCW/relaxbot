defmodule Relaxbot.MessageHandler do
  alias Relaxbot.SlackMessage
  alias Relaxbot.ReactionCounter

  use Slack

  def start_link do
    IO.puts "Starting MessageHandler"
    start_link(Application.get_env(:relaxbot, :slack_token))
  end

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
    send_message("connected", "#tcpi", slack)
  end

  def handle_message(message = %{type: "message"}, slack) do
    IO.puts "MESSAGE"
    IO.inspect message
    send_message("message unique_id is #{SlackMessage.unique_id(message)}", message.channel, slack)
  end

  def handle_message(message = %{type: "reaction_added"}, slack) do
    uid = SlackMessage.unique_id(message.item)
    IO.puts "REACTED to #{uid}"
    IO.inspect message
    send_message("Nice reaction (#{message.reaction}) to #{uid}", message.item.channel, slack)
    ReactionCounter.add(uid)
    {:ok}
  end

  def handle_message(message = %{type: "reaction_removed"}, slack) do
    uid = SlackMessage.unique_id(message.item)
    IO.puts "REACTED to #{uid}"
    IO.inspect message
    send_message("Nice reaction (#{message.reaction}) to #{uid}", message.item.channel, slack)
    ReactionCounter.remove(uid)
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
