defmodule QuickApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :quick_api,
      version: "0.1.0",
      elixir: "~> 1.10",
      preferred_cli_env: ["coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      description: "Library to quickly create an Elixir wrapper for RESTful CRUD External API",
      package: package(),
      deps: deps(),

      # Docs
      name: "QuickApi",
      source_url: "https://github.com/jrusso1020/quick_api",
      homepage_url: "https://github.com/jrusso1020/quick_api",
      docs: [
        main: "QuickApi",
        extra: ["README.md"]
      ]
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
      {:bypass, "~> 1.0", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:hackney, "~> 1.15.2"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.3.0"}
    ]
  end

  defp package do
    [
      maintainers: ["James Russo"],
      files: ["lib/**/*.ex", "mix*", "*.md"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jrusso1020/quick_api"}
    ]
  end
end
