# A simple Todo utiliy for Elixir

Todo is a small macro that helps you procrastinate more when you write Elixir code.

Just put todo messages in your code and they will be printed at compile time ; there is no overhead at runtime.


```elixir
defmodule MyApp.MyMod do
  use TODO

  @todo "0.0.1": "Finish that feature later"
  @todo "add @moduledoc"

  def function(data) when is_list(data) do
    todo "0.0.1": "support binary data"
    send_data(data)
  end

end
```

### Installation

Add the dependency in your `mix.exs` file.

```elixir
  defp deps do
    [{:todo, "> 0.0.0"}]
  end
```


### How to use

Just leave a `@todo` attribute in a module body, or use the `todo` macro inside functions. Both take the same arguments:

- A simple message. It will be printed as an info.
- A keyword list with version numbers as keys and messages as values. Messages with a version number lower than your current project version (according to your mix project file) will be printed as warnings. Theese fetures should be done.

You can set multiple todos at once :

```elixir
defmodule MyApp.MyMod do
  use TODO

  @todo "0.0.1": "Finish that feature later",
        "0.0.2": "Add this other feature"

end
```



### Configuration

#### `:print`

The print option accepts two values : `:all` or `:overdue`.

`:overdue` is the default, only unversionned and features whose version is outdated are shown. `:all` … prints all.

You can configure this at the project level in `mix.exs` or per module.

```elixir
config :todo, :print, :all
```

```elixir
defmodule MyApp.MyMod do
  use TODO, print: :all

```

Wherever it's set, `:all` always win.


The opposite value is `:overdue`. If `:all` is set for the whole project, you can disable this

### Notes

You may want to have a look at [fixme](https://github.com/henrik/fixme-elixir) too, which inspired this project.
