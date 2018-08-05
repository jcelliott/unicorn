defmodule UnicornWeb.Schema.Mutations do
  use Absinthe.Schema.Notation
  alias Unicorn.Users

  input_object :purchase_input do
    field :type, non_null(:string)
    field :name, non_null(:string)
  end

  object :user_mutations do
    field :purchase, type: :user do
      arg :input, non_null(:purchase_input)

      resolve fn %{input: input}, _context ->
        user = Users.get_by_username!("fred")
        Users.execute_action(user.id, {:purchase, input})
      end
    end
  end
end
