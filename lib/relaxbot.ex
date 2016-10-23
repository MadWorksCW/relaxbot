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
end
