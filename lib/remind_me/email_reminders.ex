defmodule RemindMe.EmailReminders do
  import Swoosh.Email

  alias RemindMe.Reminders

  @sender_name "RemindMe"
  @sender_email "info@remindme.com"

  def send_to_subscribers do
    todays_reminders = Reminders.todays_reminders()

    Enum.group_by(todays_reminders, & &1.user_id)
    |> Enum.each(fn {user_id, reminder} ->
      user = Reminders.get_user!(user_id)
      RemindMe.Mailer.deliver(build(user.email, reminder))
    end)
  end

  def build(receiver_email, reminders) do
    new()
    |> to(receiver_email)
    |> from({@sender_name, @sender_email})
    |> subject("Your reminders for today")
    |> html_body("""
    <h1>Summary Report</h1>
    #{Enum.map(reminders, &render_reminders/1)}
    """)
    |> text_body("""
    Summary Report
    #{reminders |> Enum.map(& &1.content) |> Enum.join("\n")}
    """)
  end

  defp render_reminders(reminders) do
    """
    <p>#{reminders.content}</p>
    """
  end
end
