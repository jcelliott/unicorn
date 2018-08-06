defmodule UnicornWeb.Schema do
  use Absinthe.Schema
  alias UnicornWeb.Schema.Resolvers

  import_types UnicornWeb.Schema.Types
  import_types UnicornWeb.Schema.Mutations

  query do
    @desc "Get the current user"
    field :viewer, :user do
      resolve(fn
        _, %{context: %{current_user: user}} -> {:ok, user}
        _, _ -> {:ok, nil}
      end)
    end
  end

  # When query resolution gets more complicated, you can delegate to
  # another module like this:
  #
  # query do
  #   @desc "Get the current user"
  #   field :viewer, :user do
  #     resolve &Resolvers.get_current_user/2
  #   end
  # end

  mutation do
    import_fields(:user_mutations)
  end
end
