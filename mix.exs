defmodule FIN.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :fin,
      version: "0.7.1",
      description: "BANK Financial Management",
      package: package(),
      elixir: "~> 1.7",
      deps: deps()
    ]
  end

  def package() do
    [
      files: ~w(doc include priv src mix.exs LICENSE),
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/synrc/bank"}
    ]
  end

  def application(),
    do: [mod: {:fin, []}, applications: [:rocksdb, :ranch, :cowboy, :kvs, :syn, :bpe, :nitro, :form, :n2o]]

  def deps() do
    [
      {:ex_doc, "~> 0.20.2", only: :dev},
      {:cowboy, "~> 2.5"},
      {:rocksdb, "~> 1.2.0"},
      {:bpe, "~> 4.7.3"},
      {:nitro, "~> 4.7.3"},
      {:form, "~> 4.7.0"},
      {:syn, "~> 1.6.3"},
      {:n2o, "~> 6.7.4"},
      {:kvs, "~> 6.7.4"}
    ]
  end
end
