defmodule Wiretap.Repo.Migrations.AddSidToCalls do
  use Ecto.Migration

  def change do

    alter table(:calls) do
      add :sid, :string
    end

    create unique_index(:calls, [:sid])

  end
end
