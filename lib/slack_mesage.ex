defmodule Relaxbot.SlackMessage do
  def unique_id(%{ts: ts, channel: channel, type: "message"}) do
    :crypto.hash(:sha, "#{channel}:#{ts}") |> Base.encode16
  end

  def send_message(message, channel \\ "#tcpi") do
    send(websocket_pid, {:message, message, channel})
  end

  def websocket_pid do
    pid = Supervisor.which_children(Relaxbot.Supervisor)
      |> Enum.map(&Relaxbot.SlackMessage.find_pid/1)
      |> Enum.find(fn(x) -> !!x end)
  end

  def find_pid({Relaxbot.MessageHandler, pid, :worker, _}), do: pid
  def find_pid(_), do: nil
end
