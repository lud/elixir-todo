defmodule TodoTest do
  use ExUnit.Case
  use TODO

  @todo "XX This todo has no version"
  @todo "0.0.0": "This todo should be always a warning",
        "999.999.999": "This message should not be shown without --all",
        "bad.version": "This should be tagged as invalid"

  def f do
    todo "XX This todo has no version too"

    todo "0.0.0": "This message is always outdate",
         "999.999.999": "Cannot be seen without --all"
  end

  # test "get module todos" do
  #   __MODULE__
  #   |> TODO.get_todos()
  #   |> IO.inspect(label: "module todos")
  # end

  defmodule SubModA do
    use TODO
    @todo "XX Unversionned todo in submod A"
    @todo "0.0.0": "Versionned todo in submod A"
  end

  defmodule SubModB do
    use TODO
    @todo "XX Unversionned todo in submod B"
    @todo "0.0.0": "Versionned todo in submod B"
  end

  test "get multiple modules todos" do
    todos =
      [__MODULE__, SubModA, SubModB]
      |> TODO.get_todos()
      |> IO.inspect(label: "multi module todos")

    IO.puts("Print all")
    TODO.output_todos(todos, :all, Version.parse!("1.0.0"))
    # IO.puts("Print overdue for 1.0.0")
    # TODO.output_todos(todos, :overdue, Version.parse!("1.0.0"))
  end
end
