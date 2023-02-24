defmodule RawgEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :rawg_ex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.2", only: :dev, runtime: false},
      {:finch, "~> 0.14"},
      {:gradient, github: "esl/gradient", only: :dev, runtime: false},
      {:jason, "~> 1.4"},
      {:mock, "~> 0.3.7", only: :test, runtime: false}
    ]
  end

  defp aliases do
    [
      check: ["format --check-formatted", "dialyzer", "gradient"]
    ]
  end
end
