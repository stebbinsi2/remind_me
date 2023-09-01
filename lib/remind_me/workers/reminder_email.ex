defmodule RemindMe.Workers.ReminderEmail do
  use Oban.Worker, queue: :default, max_attempts: 1


  @impl true
  def perform(_params) do
    RemindMe.EmailReminders.send_subscribed_reminders_to_users()

    :ok
  end
end
