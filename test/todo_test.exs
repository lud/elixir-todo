defmodule TodoTest do
  use ExUnit.Case
  use TODO

  @todo "This message should be shown as an info"
  @todo "0.0.0": "This message should be shown as a WARNING",
        "99.99.99": "This message SHOULD NOT BE SHOWN at compile time"

  def f do
    todo "This message should be shown as an info"
    todo "0.0.0": "This message should be shown as a WARNING",
         "99.99.99": "This message SHOULD NOT BE SHOWN at compile time"
  end

end

defmodule TodoTestPrintAll do
  use ExUnit.Case
  use TODO, print: :all

  @todo_version "0.2.0"

  @todo "This message should be shown as an info"
  @todo "0.1.0": "This message should be shown as a WARNING",
        "99.99.99": "This message should be shown as an info"

  def f do
    todo "This message should be shown as an info"
    todo "0.0.0": "This message should be shown as a WARNING",
        "99.99.99": "This message should be shown as an info"
  end

end

defmodule TodoTestPrintSilent do
  use ExUnit.Case
  use TODO, print: :silent

  @todo_version "0.2.0"

  @todo "This message should not be shown at compile time"
  @todo "0.1.0": "This message should not be shown at compile time",
        "99.99.99": "This message should not be shown at compile time"

  def f do
    todo "This message should not be shown at compile time"
    todo "0.0.0": "This message should not be shown at compile time",
        "99.99.99": "This message should not be shown at compile time"
  end

end
