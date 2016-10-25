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

    result = supervise(children, strategy: :one_for_one)
    #IO.inspect Supervisor.which_children(Relaxbot.Supervisor)

    # pid = Supervisor.which_children(Relaxbot.Supervisor)
    #    |> Enum.each(&Relaxbot.Supervisor.slack_pid/1)
    #    |> Enum.find(fn (x) -> !!x end)
    # IO.puts "SLACK PID = #{pid}"
    result
  end

end
