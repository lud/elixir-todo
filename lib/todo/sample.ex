if function_exported?(Mix, :env, 0) and
     Mix.Project.get() == Todo.MixProject and
     Mix.env() == :dev do
  defmodule Todo.Sample do
    use TODO

    @todo "This is an unversionned todo"

    @todo "99.0.0": "This is a list of features for version 99",
          "99.0.0": "Feature A",
          "99.0.0": "Feature B",
          "99.0.0": "Feature C"

    @todo "1.0.0": "This is a list of features for several versions",
          "1.2.3": "Feature C",
          "1.1.1": "Feature B",
          "1.1.0": "Feature A"
  end
end
