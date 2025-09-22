defmodule Budgeteer.Factory do
  use ExMachina.Ecto, repo: Budgeteer.Repo

  alias Budgeteer.Tracking
  alias Budgeteer.Accounts

  def without_preloads(objects) when is_list(objects), do: Enum.map(objects, &without_preloads/1)
  def without_preloads(%Tracking.Budget{} = budget), do: Ecto.reset_fields(budget, [:creator])

  def without_preloads(%Tracking.BudgetTransaction{} = transaction),
    do: Ecto.reset_fields(transaction, [:budgets])

  def user_factory do
    %Accounts.User{
      name: sequence(:user_name, &"Nawaz #{&1}"),
      email: sequence(:email, &"nawaz-#{&1}@example.com"),
      hashed_password: "-"
    }
  end

  def budget_factory do
    %Tracking.Budget{
      name: sequence(:budget_name, &"Budget #{&1}"),
      description: sequence(:budget_description, &"BUDGET DESCRIPTION #{&1}"),
      start_date: ~D[2025-01-01],
      end_date: ~D[2025-12-31],
      creator: build(:user)
    }
  end

  def budget_transaction_factory do
    %Tracking.BudgetTransaction{
      effective_date: ~D[2025-01-01],
      amount: Decimal.new(123.45),
      description: sequence(:transaction_description, &"TRANSACTION DESCRIPTION #{&1}"),
      budget: build(:budget),
      type: :spending
    }
  end
end
