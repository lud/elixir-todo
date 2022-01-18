defmodule Mix.Tasks.Todo do
  use Mix.Task
  alias Mix.Shell.IO, as: Shell

  @shortdoc "List all todos items for the current project"

  def run(argv) do
    Mix.Task.run("compile")
    config = Mix.Project.config()
    app = config[:app]
    max_vsn = Version.parse!(config[:version])

    print_mode =
      cond do
        Enum.member?(argv, "--all") -> :all
        Enum.member?(argv, "--overdue") -> :overdue
        true -> TODO.config_default(Mix.env(), :print)
      end

    app
    |> get_all_modules()
    |> TODO.get_todos()
    |> TODO.output_todos(print_mode, max_vsn)
  end

  defp get_all_modules(app) do
    appfile = Application.app_dir(app) <> "/ebin/#{app}.app"

    case :file.consult(appfile) do
      {:error, :enoent} ->
        Shell.error("File missing. App not compiled ?")
        exit(:normal)

      {:ok, [data]} ->
        {:application, _app, infos} = data
        infos[:modules] || []
    end
  end
end
