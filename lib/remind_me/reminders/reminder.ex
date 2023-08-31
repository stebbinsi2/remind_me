defmodule RemindMe.Reminders.Reminder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reminder" do
    field :title, :string
    field :content, :string
    field :remind_date, :date
    field :subscribed, :boolean, default: false

    belongs_to :user, RemindMe.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(reminder, attrs) do
    reminder
    |> cast(attrs, [:content, :user_id, :title, :remind_date, :subscribed])
    |> validate_required([:content])
  end
end
