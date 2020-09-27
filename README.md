# A simple Todo utiliy for Elixir

Todo is a small macro that helps you procrastinate more when you write Elixir code.

Just put todo messages in your code and you will be able to see them all at once in the command line.

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
    [{:todo, "~> 1.5"}]
  end
```

### How to use

Add `@todo` attributes in a module body, or use the `todo` macro inside functions. Both take the same arguments:

- A simple message. It will be printed as an info and will have no target version associated.
- A keyword list with version numbers as keys and messages as values. Messages with a version number lower than your current project version (according to your mix project file) will be printed as warnings as those features should be finished already.

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
config :todo, persist: true

# config/prod.exs
config :todo, persist: false
```

```elixir
# mymod.ex
defmodule MyApp.MyMod do
  use TODO, persist: true
end
```

### Mix command

This requires `@todo` attributes to be persistent. See the configuration to enable persistence.

Todos messages printed at compilation time are interleaved with compilation messages. Hence the color of ouverdue features. The command allows for a simpler way to read all the messages at once.

Enter `mix todo --all` or `mix todo --overdue` in your console to print all the todos of the current project at once.

### Configuration

The following configuration options is available :

#### `:print`

This option controls the default output mode of the mix command.

- `:overdue` (default value) : only unversionned and features whose version is outdated are shown.
- `:all` show all todos.

#### `:persist`

This option sets the `@todo` module attributes to be persistent. The mix command shows only persistent attributes. It accepts a boolean value :

- `true` : todos items are persitent, shown with the mix command and accessible through the Elixir module API.
- `false` : todos will only be available at compile time.

The default value is `true` so the command works out of the box with all modules. It should be set to `false` in production environment.

### Notes

You may want to have a look at [fixme](https://github.com/henrik/fixme-elixir) too, which inspired this project.
