defmodule BudgeteerWeb.BudgetListLiveTest do
  use BudgeteerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Budgeteer.TrackingFixtures

  alias Budgeteer.Tracking

  setup do
    user = Budgeteer.AccountsFixtures.user_fixture()

    %{user: user}
  end

  describe "index view" do
    test "shows budget when 1 exists", %{conn: conn, user: user} do
      budget = budget_fixture(%{creator_id: user.id})

      conn = log_in_user(conn, user)
      {:ok, _lv, html} = live(conn, ~p"/budgets")

      assert html =~ budget.name
      assert html =~ budget.description
    end
  end

  describe "create budget modal" do
    test "modal is presented", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)

      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      assert has_element?(lv, "#create-budget-modal")
    end

    test "validation errors are presented when form is changed with invalid input", %{
      conn: conn,
      user: user
    } do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form =
        form(lv, "#create-budget-modal form", %{
          "budget" => %{"name" => ""}
        })

      html = render_change(form)

      assert html =~ html_escape("can't be blank")
    end

    test "creates a budget", %{
      conn: conn,
      user: user
    } do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form =
        form(lv, "#create-budget-modal form", %{
          "budget" => %{
            "name" => "A new name",
            "description" => "The new description",
            "start_date" => "2025-01-01",
            "end_date" => "2025-01-31"
          }
        })

      {:ok, _lv, html} =
        render_submit(form)
        |> follow_redirect(conn)

      # submission_result = render_submit(form)

      # assert [created_budget] = Tracking.list_budgets()

      # {:ok, _lv, html} = follow_redirect(submission_result, conn, ~p"/budgets/#{created_budget}")

      assert html =~ "Budget created"
      assert html =~ "A new name"

      assert [created_budget] = Tracking.list_budgets()
      assert created_budget.name == "A new name"
      assert created_budget.description == "The new description"
      assert created_budget.start_date == ~D[2025-01-01]
      assert created_budget.end_date == ~D[2025-01-31]
    end

    test "validation errors are presented when form is submitted with invalid input", %{
      conn: conn,
      user: user
    } do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form =
        form(lv, "#create-budget-modal form", %{
          "budget" => %{"name" => ""}
        })

      html = render_submit(form)

      assert html =~ html_escape("can't be blank")
    end

    test "end date before start date error is presented when form is submitted with invalid dates",
         %{
           conn: conn,
           user: user
         } do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      # Creator ID isn't an input on the page, must be removed
      attrs =
        valid_budget_attributes(%{
          start_date: ~D[2025-12-31],
          end_date: ~D[2025-01-01]
        })
        |> Map.delete(:creator_id)

      form =
        form(lv, "#create-budget-modal form", %{
          budget: attrs
        })

      html = render_submit(form)

      assert html =~ "must end after start date"
    end
  end
end
