defmodule Budgeteer.Tracking do
  import Ecto.Query, warn: false

  alias Budgeteer.Repo
  alias Budgeteer.Tracking.Budget

  def create_budget(attrs \\ %{}) do
    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end
end
