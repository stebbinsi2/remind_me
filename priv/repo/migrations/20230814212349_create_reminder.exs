defmodule RemindMe.Repo.Migrations.CreateReminder do
  use Ecto.Migration

  def change do
    create table(:reminder) do
      add :title, :text
      add :content, :text
      add :remind_date, :date
      add :all_day, :boolean, default: false

      timestamps()
    end
  end
end
