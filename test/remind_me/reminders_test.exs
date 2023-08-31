defmodule RemindMe.RemindersTest do
  use RemindMe.DataCase

  alias RemindMe.Reminders
  alias RemindMe.Reminders.Reminder

  import RemindMe.RemindersFixtures
  import RemindMe.AccountsFixtures

  describe "reminder" do
    @invalid_attrs %{content: nil}

    test "list_reminder/0 returns only the logged in users reminders" do
      user1 = user_fixture()
      user2 = user_fixture()
      reminder = reminder_fixture(user_id: user1.id)
      assert Reminders.list_reminder(user1) == [reminder]
      assert Reminders.list_reminder(user2) == []
    end

    test "get_reminder!/1 returns the reminder with given id" do
      user = user_fixture()
      reminder = reminder_fixture(user_id: user.id)
      assert Reminders.get_reminder!(reminder.id) == reminder
    end

    test "create_reminder/1 with valid data creates a reminder" do
      user = user_fixture()
      valid_attrs = %{content: "some content", user_id: user.id}

      assert {:ok, %Reminder{} = reminder} = Reminders.create_reminder(valid_attrs)
      assert reminder.content == "some content"
    end

    test "create_reminder/1 with invalid data returns error changeset" do
      user = user_fixture()
      reminder = reminder_fixture(user_id: user.id)
      assert {:error, %Ecto.Changeset{}} = Reminders.create_reminder(@invalid_attrs)
    end

    test "update_reminder/2 with valid data updates the reminder" do
      user = user_fixture()
      reminder = reminder_fixture(user_id: user.id)
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Reminder{} = reminder} = Reminders.update_reminder(reminder, update_attrs)
      assert reminder.content == "some updated content"
    end

    test "update_reminder/2 with invalid data returns error changeset" do
      user = user_fixture()
      reminder = reminder_fixture(user_id: user.id)
      assert {:error, %Ecto.Changeset{}} = Reminders.update_reminder(reminder, @invalid_attrs)
      assert reminder == Reminders.get_reminder!(reminder.id)
    end

    test "delete_reminder/1 deletes the reminder" do
      user = user_fixture()
      reminder = reminder_fixture(user_id: user.id)
      assert {:ok, %Reminder{}} = Reminders.delete_reminder(reminder)
      assert_raise Ecto.NoResultsError, fn -> Reminders.get_reminder!(reminder.id) end
    end

    test "change_reminder/1 returns a reminder changeset" do
      user = user_fixture()
      reminder = reminder_fixture(user_id: user.id)
      assert %Ecto.Changeset{} = Reminders.change_reminder(reminder)
    end
  end
end
