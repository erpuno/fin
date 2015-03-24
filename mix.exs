defmodule DB.Mixfile do
  use Mix.Project

  def project do
    [app: :db,
     version: "0.9.0",
     description: "Banking Database",
     package: package]
  end

  defp package do
    [files: ~w(c_src include priv src LICENSE package.exs README.md rebar.config),
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/spawnproc/db"}]
   end
end
