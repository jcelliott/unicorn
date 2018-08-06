defmodule UnicornWeb.Schema.Mutations do
  use Absinthe.Schema.Notation
  alias Unicorn.Users

  input_object :purchase_input do
    field :type, non_null(:string)
    field :name, non_null(:string)
  end

  object :user_response do
    field :user, :user
  end

  def wrap_user_response({:ok, user}), do: {:ok, %{user: user}}
  def wrap_user_response(result), do: result

  object :user_mutations do
    @desc "Create a new user"
    field :create_user, type: :user_response do
      arg :username, non_null(:string)

      resolve fn args, _context ->
        Users.create_user(args)
        |> wrap_user_response()
      end
    end

    @desc "Make a purchase"
    field :purchase, type: :user_response do
      arg :purchase, non_null(:purchase_input)

      resolve fn %{purchase: purchase}, %{context: %{current_user: user}} ->
        Users.execute_action(user, {:purchase, purchase})
        |> IO.inspect(label: "after purchase")
        |> wrap_user_response()
      end
    end

  end
end
