defmodule RemindMe.RemindersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RemindMe.Reminders` context.
  """

  @doc """
  Generate a reminder.
  """
  def reminder_fixture(attrs \\ %{}) do
    {:ok, reminder} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> RemindMe.Reminders.create_reminder()

    reminder
  end
end
