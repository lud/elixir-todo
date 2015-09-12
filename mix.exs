defmodule Todo.Mixfile do
  use Mix.Project

  def project do
    [app: :todo,
     version: "1.0.0",
     elixir: "~> 1.0",
     description: "A small TODO comments utility.",
     package: [
       contributors: ["Ludovic Demblans"],
       licenses: ["MIT"],
       links: %{
         "GitHub" => "https://github.com/niahoo/elixir-todo",
         "Hex Docs" => "http://hexdocs.pm/todo"
       }
     ],
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.8.4", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
    ]
  end
end
