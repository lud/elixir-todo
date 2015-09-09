defmodule TODO do

  @moduledoc File.read!(__DIR__ <> "/../README.md")

  alias Mix.Shell.IO, as: Shell

  defmacro __using__(opts) do
    quote do
      Module.register_attribute(__MODULE__, :todo, accumulate: true)
      @before_compile unquote(__MODULE__)
      @todo_version Mix.Project.config[:version]
      @todo_print_mode Keyword.get(unquote(opts), :print, :overdue)

      defmacrop todo(items) do
        TODO.print_todos(__MODULE__, items, @todo_version, @todo_print_mode)
      end
    end
  end

  defmacro __before_compile__(env) do
    todos =
      Module.get_attribute(env.module, :todo)
      |> List.flatten
      |> Enum.sort(fn({v1,_}, {v2,_}) -> v1 < v2
                     # put unversionned last
                     ({_,_}, v2) when is_binary(v2) -> true
                     (v1, {_,_}) when is_binary(v1) -> false
      end)
    app_version = Module.get_attribute(env.module, :todo_version)
    mode = Module.get_attribute(env.module, :todo_print_mode)
    print_todos(env.module, todos, app_version, mode)
  end


  @doc false
  def print_todos(module, [], app_version, mode) do
    nil
  end
  def print_todos(module, [item|items], app_version, mode) do
    print_todos(module, item, app_version, mode)
    print_todos(module, items, app_version, mode)
  end

  def print_todos(module, item, app_version, mode) do
    print_todo_item(module, item, app_version, mode)
  end

  defp print_todo_item(module, {version, message}, app_version, mode) do
    # print a versionned message
    version = to_string version
    message = format_message(module, version, message)
    outconf = case {Version.compare(version, app_version), mode} do
      {:gt, :all} ->
        # Version when the feature is required is greater than the current
        # version, it's not overdue, but we're asked to print all.
        :info
      {:gt, :overdue} ->
        # Same case, but we must print only overdue items, so no-print
        :ignore
      _ ->
        # App version reached the version for the feature. It should have been
        # done before bumping the app version.
        :warn
    end
    output_todo(outconf, message)
  end

  defp print_todo_item(module, message, app_version, mode) do
    # print a bare message
    message = format_message(module, message)
    output_todo(:info, message)
  end

  defp format_message(module, version, message) do
    "@todo in #{module} for v#{version}: " <> message
  end
  defp format_message(module, message) do
    "@todo in #{module}: " <> message
  end

  defp output_todo(:ignore, message), do: nil
  defp output_todo(:warn, message) do
    Shell.print_app
    IO.puts :stderr, IO.ANSI.format(yellow(message))
  end
  defp output_todo(:info, message) do
    Shell.print_app
   IO.puts IO.ANSI.format message
  end

  defp yellow(message) do
    [:yellow, message]
  end

end
