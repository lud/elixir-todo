defmodule Todo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "1.5.1",
      elixir: "~> 1.4",
      description: "A small TODO comments utility.",
      package: [
        contributors: ["Ludovic Demblans"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => "https://github.com/lud/elixir-todo"
        }
      ],
      deps: deps()
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev}
    ]
  end
end
