defmodule Relaxbot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: Relaxbot.Supervisor)
  end

  def init(:ok) do
    IO.puts "supervisor init"
    children = [
      worker(Relaxbot.MessageHandler, []),
      worker(Relaxbot.ReactionCounter, []),
      worker(Relaxbot.MessageCache, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

end
