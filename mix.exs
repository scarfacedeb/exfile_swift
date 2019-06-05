defmodule ExfileSwift.MixProject do
  use Mix.Project

  def project do
    [
      app: :exfile_swift,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:exfile, "~> 0.3.6"},
      {:ex_swift, "~> 0.1.0", github: "scarfacedeb/ex_swift"}
    ]
  end
end
