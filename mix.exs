defmodule Kia11y.Mixfile do
  use Mix.Project

  def project do
    [app: :kia11y,
     version: "0.1.1",
     elixir: "~> 1.3",
     description: "Elixir client for the AccessLint Service A11Y Checker",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
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
      { :httpoison, "~> 0.9" },
      { :poison,    "~> 2.2 or ~> 3.0" },
      { :ex_doc,    ">= 0.0.0", only: :dev},
      { :mock,      "~> 0.1", only: :test}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Jaime Iniesta"],
      links: %{"GitHub" => "https://github.com/jaimeiniesta/kia11y"}
    ]
  end
end
