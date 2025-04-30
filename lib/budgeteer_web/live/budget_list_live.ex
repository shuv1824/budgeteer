defmodule BudgeteerWeb.BudgetListLive do
  use BudgeteerWeb, :live_view

  alias Budgeteer.Tracking

  def mount(_params, _session, socket) do
    budgets =
      Tracking.list_budgets()
      |> Budgeteer.Repo.preload(:creator)

    socket = assign(socket, budgets: budgets)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.table id="budgets" rows={@budgets}>
      <:col :let={budget} label="Name">{budget.name}</:col>
      <:col :let={budget} label="Description">{budget.description}</:col>
      <:col :let={budget} label="Start Date">{budget.start_date}</:col>
      <:col :let={budget} label="End Date">{budget.end_date}</:col>
      <:col :let={budget} label="Creator">{budget.creator.name}</:col>
    </.table>
    """
  end
end
