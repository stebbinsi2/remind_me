defmodule RemindMe.Repo.Migrations.AddUserIdToReminders do
  use Ecto.Migration

  def change do
    alter table(:reminder) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
    end
  end
end
