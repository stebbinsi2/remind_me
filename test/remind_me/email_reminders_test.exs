defmodule RemindMe.EmailRemindersTest do
  use RemindMe.DataCase, async: true
  doctest RemindMe.EmailReminders
  alias RemindMe.EmailReminders
  import Swoosh.TestAssertions
  import RemindMe.AccountsFixtures
  import RemindMe.RemindersFixtures

  test "send_to_subscribers" do
    user = user_fixture()
    reminder = reminder_fixture(user_id: user.id, subscribed: true, remind_date: Date.utc_today())

    EmailReminders.send_to_subscribers()
    assert_email_sent(EmailReminders.build(user.email, [reminder]))
  end
end
