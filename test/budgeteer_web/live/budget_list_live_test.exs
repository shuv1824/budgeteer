defmodule BudgeteerWeb.BudgetListLiveTest do
  use BudgeteerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Budgeteer.TrackingFixtures

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
end
