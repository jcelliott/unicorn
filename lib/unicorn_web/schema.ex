defmodule UnicornWeb.Schema do
  use Absinthe.Schema
  alias Unicorn.Users

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

    @desc "List all available purchases"
    field :purchases, non_null(list_of(:purchase_item)) do
      resolve(fn _, _ -> {:ok, Users.Purchase.available_purchases()} end)
    end

    @desc "List all users"
    field :users, non_null(list_of(:user)) do
      arg :sort_by, :string
      arg :limit, :integer
      resolve(fn args, _ ->
        {:ok, Users.list_users(args)}
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

  # if it's a field for the mutation object, add this middleware to the end
  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [UnicornWeb.Schema.HandleChangesetErrors]
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, _object), do: middleware

  def get_string_key(%{source: source} = res, key) do
    %{res | state: :resolved, value: Map.get(source, key)}
  end
end
