defmodule Wiretap.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do

    create table(:contacts) do
      add :name, :string, null: false
      add :phone_number, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:contacts, [:user_id])

  end
end
