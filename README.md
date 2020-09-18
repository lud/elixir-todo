# A simple Todo utility for Elixir

Todo is a small macro that helps you procrastinate more when you write Elixir code.

Just put todo messages in your code and they will be printed at compile time ; there is no overhead at runtime.

A [mix command](#mix-command) is available to scan all modules for todo items and print all at once.


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
    [{:todo, "~> 1.4"}]
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

Configuration options can be set at module level or at project level. In-module configuration takes precedence over the global configuration.


```elixir
# config/dev.exs
config :todo, print: :all, persist: true

# config/prod.exs
config :todo, print: :silent, persist: false
```

```elixir
# mymod.ex
defmodule MyApp.MyMod do
  use TODO, print: :all, persist: true
end
```

The following configuration options are available :

#### `:print`

This option controls the output at compile time and accepts the following values :

- `:overdue` (default value) : only unversionned and features whose version is outdated are shown.
- `:all` show all todos.
- `:silent` : no output.


#### `:persist`

This option sets the `@todo` module attributes to be persistent. The mix command shows only persistent attributes. It accepts a boolean value :

- `true` : todos items are persitent, shown with the mix command and accessible through the Elixir module API.
- `false` : todos will only be available at compile time.


### Mix command

This requires `@todo` attributes to be persistant. See the configuration to enable persistance.

Todos messages printed at compilation time are interleaved with compilation messages. Hence the color of ouverdue features. The command allows for a simpler way to read all the messages at once.

Enter `mix todo --all` or `mix todo --overdue` in your console to print all the todos of the current project at once.

### Notes

You may want to have a look at [fixme](https://github.com/henrik/fixme-elixir) too, which inspired this project.
