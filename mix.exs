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
    do: [mod: {:fin, []}, applications: [:public_key, :asn1, :rocksdb, :ranch, :cowboy, :kvs, :syn, :bpe, :nitro, :form, :n2o]]

  def deps() do
    [
      {:ex_doc, "~> 0.20.2", only: :dev},
      {:rpc, "~> 0.9.2"},
      {:cowboy, "~> 2.5"},
      {:rocksdb, "~> 1.3.2"},
      {:bpe, "~> 4.9.4"},
      {:nitro, "~> 4.7.3"},
      {:form, "~> 4.7.0"},
      {:syn, "~> 1.6.3"},
      {:n2o, "~> 6.8.1"}
    ]
  end
end
