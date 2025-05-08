defmodule LpoStats.MixProject do
  use Mix.Project

  def project do
    [
      app: :lpo_stats,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "LPOStats",
      source_url: "https://github.com/USER/PROJECT",
      homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: &docs/0
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end

  defp docs do
    [
      main: "LPOStats", # The main page in the docs
      # logo: "",
      extras: ["README.md"]
    ]
  end
end
