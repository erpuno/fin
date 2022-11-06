defmodule FIN.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :fin,
      version: "3.11.3",
      description: "FIN Client Account Transaction Management",
      package: package(),
      elixir: "~> 1.11",
      deps: deps()
    ]
  end

  def package() do
    [
      files: ~w(doc include priv src mix.exs LICENSE),
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/erpuno/fin"}
    ]
  end

  def application(),
    do: [mod: {:fin, []},
         applications: [:rocksdb,:ranch,:cowboy,:kvs,:syn,:bpe,:nitro,:form,:n2o]]

  def deps() do
    [
      {:ex_doc, "~> 0.20.2", only: :dev},
      {:cowboy, "~> 2.9.0"},
      {:rocksdb, "~> 1.6.0"},
      {:syn, "2.1.0"},
      {:bpe, "~> 7.11.0"},
      {:nitro, "~> 7.8.0"},
      {:form, "~> 7.8.0"},
      {:kvs, "~> 9.4.8"},
      {:n2o, "~> 9.4.0"}
    ]
  end
end
