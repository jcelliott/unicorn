defmodule Unicorn.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:username, :string)
      add(:code, :integer)
      add(:code_rate, :integer)
      add(:bugs, :integer)
      add(:bug_rate, :integer)
      add(:money, :integer)
      add(:revenue_rate, :integer)
      add(:expense_rate, :integer)
      add(:capacity, :integer)
      add(:employees, :map)
      add(:upgrades, :map)

      timestamps()
    end

    create unique_index(:users, [:username])

  end
end
