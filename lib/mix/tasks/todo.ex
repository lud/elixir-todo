defmodule Mix.Tasks.Todo do
  use Mix.Task
  alias Mix.Shell.IO, as: Shell

  @shortdoc "List all todos items for the current project"

  def run(_) do
    Mix.Task.run "compile"
    config = Mix.Project.config
    app = config[:app]
    appfile = Application.app_dir(app) <> "/ebin/#{app}.app"

    # Shell.info "Reading modules from #{appfile} ..."
    read_app :file.consult(appfile)
  end

  def read_app({:error, :enoent}) do
    Shell.error "File missing. App not compiled ?"
  end
  def read_app({:ok, [data]}) do
    {:application, _app, infos} = data
    infos[:modules] |> Enum.map(&read_module/1)
  end

  def read_module(module) do
    module.module_info(:attributes)
    |> Keyword.get_values(:todo)
    |> TODO.output_todos(module, Mix.Project.config[:version], :all)
  end

end
