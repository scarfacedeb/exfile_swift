defmodule ExfileSwift.MixProject do
  use Mix.Project

  def project do
    [
      app: :exfile_swift,
      version: "0.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Exfile backend for OpenStack Swift storage, based on ExSwift",
      package: package()
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
      {:ex_swift, "~> 0.2.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Andrew Volozhanin"],
      links: %{"Github" => "https://github.com/scarfacedeb/exfile_swift"}
    ]
  end
end
