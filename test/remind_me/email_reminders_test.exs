defmodule RemindMe.EmailRemindersTest do
  use RemindMe.DataCase, async: true
  doctest RemindMe.EmailReminders
  alias RemindMe.EmailReminders
  import Swoosh.TestAssertions
  import RemindMe.AccountsFixtures
  import RemindMe.RemindersFixtures

  test "send_subscribed_reminders_to_users _ one user _ one reminder" do
    user = user_fixture()
    reminder = reminder_fixture(user_id: user.id, subscribed: true, remind_date: Date.utc_today())

    EmailReminders.send_to_subscribers()
    assert_email_sent(EmailReminders.build(user.email, [reminder]))
  end

  test "send_subscribed_reminders_to_users _ one user _ two reminders" do
    user = user_fixture()
    reminder1 = reminder_fixture(user_id: user.id, subscribed: true, remind_date: Date.utc_today())
    reminder2 = reminder_fixture(user_id: user.id, subscribed: true, remind_date: Date.utc_today())

    EmailReminders.send_to_subscribers()
    assert_email_sent(EmailReminders.build(user.email, [reminder1, reminder2]))
  end

  test "send_subscribed_reminders_to_users _ two users _ one reminder each" do
    user1 = user_fixture()
    user2 = user_fixture()
    reminder1 = reminder_fixture(user_id: user1.id, subscribed: true, remind_date: Date.utc_today())
    reminder2 = reminder_fixture(user_id: user2.id, subscribed: true, remind_date: Date.utc_today())

    EmailReminders.send_to_subscribers()
    assert_email_sent(EmailReminders.build(user1.email, [reminder1]))
    assert_email_sent(EmailReminders.build(user2.email, [reminder2]))
  end

  test "send_subscribed_reminders_to_users _ two users _ two reminders each" do
    user1 = user_fixture()
    user2 = user_fixture()
    reminder1 = reminder_fixture(user_id: user1.id, subscribed: true, remind_date: Date.utc_today())
    reminder2 = reminder_fixture(user_id: user1.id, subscribed: true, remind_date: Date.utc_today())
    reminder3 = reminder_fixture(user_id: user2.id, subscribed: true, remind_date: Date.utc_today())
    reminder4 = reminder_fixture(user_id: user2.id, subscribed: true, remind_date: Date.utc_today())

    EmailReminders.send_to_subscribers()
    assert_email_sent(EmailReminders.build(user1.email, [reminder1, reminder2]))
    assert_email_sent(EmailReminders.build(user2.email, [reminder3, reminder4]))
  end

  test "send_subscribed_reminders_to_users _ two users _ two reminders each _ one reminder not subscribed" do
    user1 = user_fixture()
    user2 = user_fixture()
    reminder1 = reminder_fixture(user_id: user1.id, subscribed: true, remind_date: Date.utc_today())
    reminder2 = reminder_fixture(user_id: user1.id, subscribed: true, remind_date: Date.utc_today())
    reminder3 = reminder_fixture(user_id: user2.id, subscribed: false, remind_date: Date.utc_today())
    reminder4 = reminder_fixture(user_id: user2.id, subscribed: true, remind_date: Date.utc_today())

    EmailReminders.send_to_subscribers()
    assert_email_sent(EmailReminders.build(user1.email, [reminder1, reminder2]))
    assert_email_sent(EmailReminders.build(user2.email, [reminder4]))
    assert_email_not_sent(EmailReminders.build(user2.email, [reminder3]))
  end
end
