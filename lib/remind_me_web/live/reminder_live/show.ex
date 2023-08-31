defmodule RemindMeWeb.ReminderLive.Show do
  use RemindMeWeb, :live_view

  alias RemindMe.Reminders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:reminder, Reminders.get_reminder!(id))}
  end

  defp page_title(:show), do: "Show Reminder"
  defp page_title(:edit), do: "Edit Reminder"
end
