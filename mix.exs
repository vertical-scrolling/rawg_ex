defmodule RawgEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :rawg_ex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.2", only: [:dev, :test]},
      {:finch, "~> 0.14"},
      {:gradient, github: "esl/gradient", only: [:dev], runtime: false},
      {:jason, "~> 1.4"}
    ]
  end
end
