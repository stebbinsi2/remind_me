defmodule RemindMe.EmailReminders do
  import Swoosh.Email

  @sender_name "RemindMe"
  @sender_email "info@remindme.com"

  def send_to_subscribers do
    messages = RemindMe.Reminders.remind_date_messages()
    subscribers = RemindMe.Reminders.subscriber_emails()

    for subscriber <- subscribers do
      RemindMe.Mailer.deliver(build(subscriber, messages))
    end
  end

  def build(receiver_email, messages) do
    new()
    |> to(receiver_email)
    |> from({@sender_name, @sender_email})
    |> subject("Your reminders for today")
    |> html_body("""
    <h1>Summary Report</h1>
    #{Enum.map(messages, &render_message/1)}
    """)
    |> text_body("""
    Summary Report
    #{messages |> Enum.map(&(&1.content)) |> Enum.join("\n")}
    """)
  end

  defp render_message(message) do
    """
    <p>#{message.content}</p>
    """
  end
end
