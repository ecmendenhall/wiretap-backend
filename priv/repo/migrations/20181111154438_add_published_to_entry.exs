defmodule Wiretap.Repo.Migrations.AddPublishedToEntry do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :published, :boolean, null: false, default: false
    end

    create index(:entries, :published)
  end
end
