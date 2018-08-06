defmodule UnicornWeb.Schema.HandleChangesetErrors do
  @behaviour Absinthe.Middleware
  def call(resolution, _) do
    %{resolution | errors: Enum.flat_map(resolution.errors, &handle_error/1)}
  end

  defp handle_error(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, bindings} ->
      Gettext.gettext(UnicornWeb.Gettext, msg, bindings)
    end)
    |> Enum.map(fn {field, errors} ->
      %{message: "#{field} #{Enum.join(errors, ",")}"}
    end)
  end

  defp handle_error(error), do: [error]
end
