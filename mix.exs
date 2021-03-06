defmodule Relaxbot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :relaxbot,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: [test: "test --no-start"]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :httpoison, :slack, :extwitter],
      mod: {Relaxbot, []},
      env: [slack_token: nil]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.9.0"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.6"},
      # {:slack, github: "BlakeWilliams/Elixir-Slack"}
      {:slack, github: "samsonasu/Elixir-Slack", branch: 'bs-fix-info-handler'}
    ]
  end
end
