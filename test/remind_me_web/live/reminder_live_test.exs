defmodule RemindMeWeb.ReminderLiveTest do
  use RemindMeWeb.ConnCase

  import Phoenix.LiveViewTest
  import RemindMe.RemindersFixtures
  import RemindMe.AccountsFixtures

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  describe "Index" do
    test "lists all of current users reminders", %{conn: conn} do
      user = user_fixture()
      conn = conn |> log_in_user(user)
      reminder = reminder_fixture(user_id: user.id)
      {:ok, _index_live, html} = live(conn, ~p"/reminder")

      assert html =~ "Listing Reminder"
      assert html =~ reminder.content
    end

    test "saves new reminder", %{conn: conn} do
      user = user_fixture()
      conn = conn |> log_in_user(user)

      {:ok, index_live, _html} = live(conn, ~p"/reminder")

      assert index_live |> element("a", "New Reminder") |> render_click() =~
               "New Reminder"

      assert_patch(index_live, ~p"/reminder/new")

      assert index_live
             |> form("#reminder-form", reminder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#reminder-form", reminder: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reminder")

      html = render(index_live)
      assert html =~ "Reminder created successfully"
      assert html =~ "some content"
    end

    test "updates reminder in listing", %{conn: conn} do
      user = user_fixture()
      conn = conn |> log_in_user(user)
      reminder = reminder_fixture(user_id: user.id)

      {:ok, index_live, _html} = live(conn, ~p"/reminder")

      assert index_live |> element("#reminder-#{reminder.id} a", "Edit") |> render_click() =~
               "Edit Reminder"

      assert_patch(index_live, ~p"/reminder/#{reminder}/edit")

      assert index_live
             |> form("#reminder-form", reminder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#reminder-form", reminder: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reminder")

      html = render(index_live)
      assert html =~ "Reminder updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes reminder in listing", %{conn: conn} do
      user = user_fixture()
      reminder = reminder_fixture(user_id: user.id)
      conn = log_in_user(conn, user)

      {:ok, index_live, _html} = live(conn, ~p"/reminder")

      assert index_live |> element("#reminder-#{reminder.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#reminder-#{reminder.id}")
    end
  end

  describe "Show" do

    test "displays reminder", %{conn: conn} do
      user = user_fixture()
      reminder = reminder_fixture(user_id: user.id)
      {:ok, _show_live, html} = live(conn, ~p"/reminder/#{reminder}")

      assert html =~ "Show Reminder"
      assert html =~ reminder.content
    end

    test "updates reminder within modal", %{conn: conn} do
      user = user_fixture()
      conn = conn |> log_in_user(user)
      reminder = reminder_fixture(user_id: user.id)

      {:ok, show_live, _html} = live(conn, ~p"/reminder/#{reminder}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Reminder"

      assert_patch(show_live, ~p"/reminder/#{reminder}/show/edit")

      assert show_live
             |> form("#reminder-form", reminder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#reminder-form", reminder: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/reminder/#{reminder}")

      html = render(show_live)
      assert html =~ "Reminder updated successfully"
      assert html =~ "some updated content"
    end
  end
end
