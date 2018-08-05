defmodule Unicorn.Users.Action do
  @moduledoc """
  Handles validating and executing actions a user can perform
  """

  alias Unicorn.Users.Purchase
  alias Unicorn.Users.GameData

  def execute(game_data, {:purchase, purchase}) do
    case Purchase.execute(game_data, purchase) do
      {:error, reason} -> {:error, reason}
      data -> {:ok, data}
    end
  end

end
