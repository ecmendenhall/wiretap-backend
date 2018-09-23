defmodule Wiretap.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do

    create table(:entries) do
      add :title, :string, null: false
      add :summary, :text, null: false
      add :keywords, :string, null: false
      add :is_explicit, :boolean, null: false

      add :feed_id, references(:feeds, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:entries, [:feed_id])

    alter table(:calls) do
      add :entry_id, references(:entries, on_delete: :nilify_all)
    end

    create unique_index(:calls, [:entry_id])

  end
end
