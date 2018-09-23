defmodule Wiretap.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do

    create table(:feeds) do
      add :title, :string, null: false
      add :summary, :text, null: false
      add :keywords, :string, null: false
      add :is_explicit, :boolean, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:feeds, [:user_id])

  end
end
