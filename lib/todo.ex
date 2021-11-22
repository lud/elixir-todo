defmodule TODO do
  @moduledoc File.read!(__DIR__ <> "/../README.md")

  def config_default(:persist), do: true
  def config_default(:print), do: :overdue

  def config(key) do
    Application.get_env(:todo, key, config_default(key))
  end

  def validate_print_conf(nil), do: :ok
  def validate_print_conf(:all), do: :ok
  def validate_print_conf(:overdue), do: :ok

  def validate_print_conf(value) do
    raise "Bad print configuration value #{inspect(value)}."
  end

  defmacro __using__(opts) do
    persist_conf = false !== Keyword.get(opts, :persist, config(:persist))

    if persist_conf and Mix.env() not in ~w(dev test)a do
      spawn_prod_persist_warning()
    end

    quote do
      Module.register_attribute(__MODULE__, :todo,
        accumulate: true,
        persist: unquote(persist_conf)
      )

      import TODO, only: [todo: 1]
    end
  end

  defmacro todo(items) do
    Module.put_attribute(__CALLER__.module, :todo, items)
    []
  end

  defp spawn_prod_persist_warning() do
    name = :todo_prod_warning_process

    case Process.whereis(name) do
      nil ->
        print_warning()
        holder = spawn(fn -> Process.sleep(:infinity) end)
        Process.register(holder, name)

      _ ->
        :ok
    end
  end

  defp print_warning() do
    IO.warn("""
    TODO attributes are persisted whereas environment is neither :dev nor :test.

    You can disable persistence in your configuration, for instance in
    config/prod.exs :

        config :todo, persist: false
    """)
  end

  def get_todos(module) when is_atom(module) do
    for {:todo, sublist} <- module.module_info(:attributes) do
      sublist
    end
    |> :lists.flatten()
    |> Enum.map(&put_meta(&1, module))
  end

  def get_todos(modules) when is_list(modules) do
    modules
    |> Enum.map(&get_todos/1)
    |> :lists.flatten()
  end

  defp put_meta({vsn, msg}, module) do
    vsn = if is_atom(vsn), do: Atom.to_string(vsn), else: vsn

    case Version.parse(vsn) do
      {:ok, vsn} -> {vsn, module, msg}
      :error -> {:no_version, module, "(Invalid vsn) #{msg}"}
    end
  end

  defp put_meta(msg, module), do: {:no_version, module, msg}

  def output_todos(todos, print_spec, %Version{} = max_vsn)
      when length(todos) > 0 and print_spec in [:all, :overdue] do
    groups =
      case print_spec do
        :all -> todos
        :overdue -> filter_overdue(todos, max_vsn)
      end
      # Group by version
      |> Enum.group_by(&elem(&1, 0))

    {unversionned, versionned} =
      case Map.pop(groups, :no_version) do
        {nil, versionned} -> {[], versionned}
        tuple -> tuple
      end

    versionned = Enum.sort_by(versionned, &elem(&1, 0), Version) |> :lists.reverse()

    {:ok, width} = :io.columns()
    width = min(width, 70)

    # Main title
    [String.pad_trailing("-- TODO ", width, "-"), "\n"]
    |> IO.puts()

    if length(unversionned) > 0 do
      output_vsn_group(unversionned, version_title("Unversionned"), :normal, width)
      |> IO.puts()
    end

    versionned
    |> Enum.map(fn {vsn, todos} ->
      mode = colorspec(vsn, max_vsn)

      title = version_title(vsn, mode)

      output_vsn_group(todos, title, mode, width)
      |> IO.puts()
    end)
  end

  def output_todos(todos, print_spec, %Version{})
      when length(todos) == 0 and print_spec in [:all, :overdue] do
    case print_spec do
      :all ->
        IO.puts("No todos found.")

      :overdue ->
        IO.puts("No overdue todos. You're fine.")
    end
  end

  defp colorspec(vsn, max_vsn) do
    if overdue?(vsn, max_vsn),
      do: :warn,
      else: :normal
  end

  defp output_vsn_group(todos, title, mode, width) do
    todos_by_mods =
      todos
      |> group_by_module()
      |> Enum.map(fn {module, todos} ->
        todolist = Enum.map(todos, &["– ", todo_to_string(&1, width, 2), "\n"])

        {todolist, module_color} =
          case mode do
            :normal -> {todolist, :cyan}
            :warn -> {color(todolist, :yellow), :light_red}
          end

        source_link = format_module_link(module)

        [
          color([inspect(module)], module_color),
          source_link,
          "\n",
          todolist
        ]
      end)
      |> Enum.intersperse("\n")

    [title, "\n\n", todos_by_mods, "\n"]
  end

  defp wrap_block(str, width, indent) do
    line_prefix = String.duplicate(" ", indent)

    str
    # Splitting block on two consecutive line breaks to preserve paragraphs but
    # not simple breaks
    |> String.split("\n\n")
    |> Enum.map(&wrap_line(&1, width - indent, line_prefix))
    |> Enum.intersperse("\n\n")
  end

  defp wrap_line(str, width, line_prefix) do
    words =
      str
      |> String.replace("\n", " ")
      |> String.split(" ", trim: true)

    Enum.reduce(words, {[], 0}, fn word, {line, len} ->
      wlen = String.length(word)

      if wlen + len > width do
        {[word, ["\n", line_prefix] | line], wlen}
      else
        case len do
          0 -> {[word | line], len + wlen + 1}
          _ -> {[word, " " | line], len + wlen + 1}
        end
      end
    end)
    |> elem(0)
    |> :lists.reverse()
  end

  defp group_by_module(todos) do
    todos
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.sort_by(&elem(&1, 0))
  end

  # Return only todos whose version is lower or equal to max_vsn
  defp filter_overdue(todos, max_vsn) do
    Enum.filter(todos, fn
      {:no_version, _, _} -> true
      {vsn, _, _} -> overdue?(vsn, max_vsn)
    end)
  end

  defp color(msg, col) do
    [apply(IO.ANSI, col, []), msg, IO.ANSI.default_color()]
  end

  defp todo_to_string({_, _, msg}, width, indent) do
    if is_binary(msg) do
      msg
    else
      inspect(msg)
    end
    |> String.trim()
    |> wrap_block(width, indent)
  end

  defp overdue?(vsn, max_vsn) do
    Version.compare(vsn, max_vsn) != :gt
  end

  defp version_title(%Version{} = vsn, :normal),
    do: version_title("Version #{vsn}")

  defp version_title(%Version{} = vsn, :warn),
    do: color(version_title("Version #{vsn} – OVERDUE"), :light_red)

  defp version_title(title),
    do: "# #{title}"

  defp format_module_link(module) do
    case get_module_source(module) do
      nil -> []
      path -> [color([" ", path], :light_black)]
    end
  end

  defp get_module_source(module) do
    compile_info = module.module_info(:compile)

    case Keyword.fetch(compile_info, :source) do
      :error ->
        nil

      {:ok, source} ->
        source
        |> to_string()
        |> Path.relative_to(File.cwd!())
    end
  end
end
