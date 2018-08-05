defmodule UnicornWeb.Schema do
  use Absinthe.Schema
  alias UnicornWeb.Schema.Resolvers

  import_types UnicornWeb.Schema.Types
  import_types UnicornWeb.Schema.Mutations

  query do
    @desc "Get the current user"
    field :viewer, :user do
      resolve &Resolvers.get_current_user/2
    end
  end

  mutation do
    import_fields(:user_mutations)
  end
end
