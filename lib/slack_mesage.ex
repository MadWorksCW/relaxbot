defmodule Relaxbot.SlackMessage do
  def unique_id(%{ts: ts, channel: channel, type: "message"}) do
    :crypto.hash(:sha, "#{channel}:#{ts}") |> Base.encode16
  end

  def send_message(message, channel \\ "#tcpi") do
    send(Relaxbot.MessageHandler, {:message, message, channel})
  end
end
