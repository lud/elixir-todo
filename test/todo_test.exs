defmodule TodoTest do
  use ExUnit.Case
  use TODO

  @todo "This message should be shown as an info"
  @todo "0.0.0": "This message should be shown as a WARNING",
        "99.99.99": "This message SHOULD NOT BE SHOWN"

  def f do
    todo "This message should be shown as an info"
    todo "0.0.0": "This message should be shown as a WARNING",
         "99.99.99": "This message SHOULD NOT BE SHOWN"
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
