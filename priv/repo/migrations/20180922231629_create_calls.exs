defmodule Wiretap.Repo.Migrations.CreateCalls do
  use Ecto.Migration

  def change do

    create table(:calls) do
      add :recording_url, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :contact_id, references(:contacts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:calls, [:user_id])
    create index(:calls, [:contact_id])
    create index(:calls, [:user_id, :contact_id])

  end
end
