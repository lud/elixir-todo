defmodule Todo.Mixfile do
  use Mix.Project

  def project do
    [app: :todo,
     version: "1.3.0",
     elixir: "~> 1.4",
     description: "A small TODO comments utility.",
     package: [
       maintainers: ["niahoo osef <dev@ooha.in>"],
       licenses: ["MIT"],
       links: %{
         "GitHub" => "https://github.com/niahoo/elixir-todo"
       }
     ],
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.8", only: :dev},
    ]
  end
end
