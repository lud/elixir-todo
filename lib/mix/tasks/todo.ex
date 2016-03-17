defmodule Mix.Tasks.Todo do
  use Mix.Task
  alias Mix.Shell.IO, as: Shell

  @shortdoc "List all todos items for the current project"

  def run(argv) do
    Mix.Task.run "compile"
    config = Mix.Project.config
    app = config[:app]
    appfile = Application.app_dir(app) <> "/ebin/#{app}.app"

    print_conf = cond do
      Enum.member?(argv, "--all") -> :all
      Enum.member?(argv, "--overdue") -> :overdue
      Enum.member?(argv, "--silent") -> :silent
      true -> TODO.config_default(:print)
    end

    # Shell.info "Reading modules from #{appfile} ..."
    read_app(:file.consult(appfile), print_conf)
  end

  def read_app({:error, :enoent}, _) do
    Shell.error "File missing. App not compiled ?"
  end
  def read_app({:ok, [data]}, print_conf) do
    {:application, _app, infos} = data
    infos[:modules] |> Enum.map(&(read_module(&1, print_conf)))
  end

  def read_module(module, print_conf) do
    module.module_info(:attributes)
    |> Keyword.get_values(:todo)
    |> TODO.output_todos(module, Mix.Project.config[:version], print_conf)
  end

end
