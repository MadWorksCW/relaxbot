defmodule SlackMessage do
  def unique_id(%{ts: ts, channel: channel, type: "message"}) do
    :crypto.hash(:sha, "#{channel}:#{ts}") |> Base.encode16
  end
end
