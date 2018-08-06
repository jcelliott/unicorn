defmodule Unicorn.Users.Release do
  @moduledoc """
  Models a user releasing a product
  """

  alias Unicorn.Users.User

  @base_code_to_revenue 50
  @code_penalty 10_000

  def execute(%User{} = user) do
    code = max(user.code - @code_penalty, 0)

    %{
      revenue_rate: user.revenue_rate + div(code, @base_code_to_revenue),
      code: 0
    }
  end
end
