defmodule Budgeteer.TrackingTest do
  use Budgeteer.DataCase

  alias Budgeteer.Tracking

  describe "budgets" do
    alias Budgeteer.Tracking.Budget

    test "create_budget/2 with valid data creates a budget" do
      user = Budgeteer.AccountsFixtures.user_fixture()

      valid_attrs = %{
        name: "some name",
        description: "some description",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-01-31],
        creator_id: user.id
      }

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == "some name"
      assert budget.description == "some description"
      assert budget.start_date == ~D[2025-01-01]
      assert budget.end_date == ~D[2025-01-31]
      assert budget.creator_id == user.id
    end
  end
end
