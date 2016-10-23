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

    result = supervise(children, strategy: :one_for_one)
    #IO.inspect Supervisor.which_children(Relaxbot.Supervisor)
    result
  end
end
