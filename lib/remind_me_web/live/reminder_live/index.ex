defmodule RemindMeWeb.ReminderLive.Index do
  use RemindMeWeb, :live_view

  alias RemindMe.Reminders
  alias RemindMe.Reminders.Reminder

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(socket, :reminder_collection, Reminders.list_reminder(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Reminder")
    |> assign(:reminder, Reminders.get_reminder!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Reminder")
    |> assign(:reminder, %Reminder{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reminder")
    |> assign(:reminder, nil)
  end

  @impl true
  def handle_info({RemindMeWeb.ReminderLive.FormComponent, {:saved, reminder}}, socket) do
    {:noreply, stream_insert(socket, :reminder_collection, reminder)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reminder = Reminders.get_reminder!(id)
    {:ok, _} = Reminders.delete_reminder(reminder)

    {:noreply, stream_delete(socket, :reminder_collection, reminder)}
  end
end
