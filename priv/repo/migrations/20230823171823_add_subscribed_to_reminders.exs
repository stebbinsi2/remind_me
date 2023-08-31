defmodule RemindMe.Repo.Migrations.AddSubscribedToReminders do
  use Ecto.Migration

  def change do
    alter table(:reminder) do
      add(:subscribed, :boolean, default: false)
    end
  end
end
