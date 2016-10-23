defmodule Relaxbot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    IO.puts "supervisor init"
    children = [
      worker(Relaxbot.MessageHandler, []),
      worker(Relaxbot.ReactionCounter, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
