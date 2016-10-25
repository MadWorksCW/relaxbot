defmodule Relaxbot do
  use Application

  def start(_type, _args) do
    IO.puts "Starting Relaxbot"
    Relaxbot.Supervisor.start_link
  end

  def stop do
    IO.puts "Stopping relaxbot"
    {:ok}
  end

  defp slack_pid({Relaxbot.MessageHandler, pid, :worker, _}), do: pid
  defp slack_pid(_), do: false
end
