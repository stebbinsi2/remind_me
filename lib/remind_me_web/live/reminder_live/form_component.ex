defmodule RemindMeWeb.ReminderLive.FormComponent do
  use RemindMeWeb, :live_component

  alias RemindMe.Reminders
  alias RemindMe.Workers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage reminder records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="reminder-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:remind_date]} type="date" label="Due Date" />
        <.input field={@form[:subscribed]} type="checkbox" label="Receive email Reminders" />
        <:actions>
          <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
          <.button phx-disable-with="Saving...">Save Reminder</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{reminder: reminder} = assigns, socket) do
    changeset = Reminders.change_reminder(reminder)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"reminder" => reminder_params}, socket) do
    changeset =
      socket.assigns.reminder
      |> Reminders.change_reminder(reminder_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"reminder" => reminder_params}, socket) do
    save_reminder(socket, socket.assigns.action, reminder_params)
  end

  defp save_reminder(socket, :edit, reminder_params) do
    case Reminders.update_reminder(socket.assigns.reminder, reminder_params) do
      {:ok, reminder} ->
        notify_parent({:saved, reminder})

        {:noreply,
         socket
         |> put_flash(:info, "Reminder updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_reminder(socket, :new, reminder_params) do
    case Reminders.create_reminder(reminder_params) do
      {:ok, reminder} ->
        notify_parent({:saved, reminder})
        Workers.ReminderEmail.new(reminder, schedule_at: reminder.remind_date) |> Oban.insert()

        {:noreply,
         socket
         |> put_flash(:info, "Reminder created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
