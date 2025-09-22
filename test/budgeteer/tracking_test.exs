defmodule Budgeteer.TrackingTest do
  use Budgeteer.DataCase

  import Budgeteer.TrackingFixtures

  alias Budgeteer.Tracking

  describe "budgets" do
    alias Budgeteer.Tracking.Budget

    test "create_budget/2 with valid data creates a budget" do
      attrs = params_with_assocs(:budget)

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(attrs)
      assert budget.name == attrs.name
      assert budget.description == attrs.description
      assert budget.start_date == attrs.start_date
      assert budget.end_date == attrs.end_date
      assert budget.creator_id == attrs.creator_id
    end

    test "create_budget/2 requires name" do
      attrs_without_name =
        valid_budget_attributes()
        |> Map.delete(:name)

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(attrs_without_name)

      assert changeset.valid? == false
      assert Keyword.keys(changeset.errors) == [:name]
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_budget/2 requires valid dates" do
      user = Budgeteer.AccountsFixtures.user_fixture()

      attrs_end_before_start = %{
        name: "some name",
        description: "some description",
        start_date: ~D[2025-12-01],
        end_date: ~D[2025-01-31],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Tracking.create_budget(attrs_end_before_start)

      assert changeset.valid? == false
      assert %{end_date: ["must end after start date"]} = errors_on(changeset)
    end

    test "list_budgets/0 returns all budgets" do
      budgets = insert_pair(:budget)
      assert Tracking.list_budgets() == without_preloads(budgets)
    end

    # test "list_budgets/1 scopes to the provided user" do
    #   user = Budgeteer.AccountsFixtures.user_fixture()
    #
    #   budget = budget_fixture(%{creator_id: user.id})
    #   _other_budget = budget_fixture()
    #
    #   assert Tracking.list_budgets(user: user) == [budget]
    # end

    test "get_budget/1 returns the budget with given id" do
      budget = budget_fixture()

      assert Tracking.get_budget(budget.id) == budget
    end

    test "get_budget/1 returns nil if no budget is found" do
      _unrelated_budget = budget_fixture()

      assert is_nil(Tracking.get_budget("45258592-6968-493c-90f3-e1795573e4af"))
    end
  end
end
