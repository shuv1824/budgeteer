defmodule Budgeteer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BudgeteerWeb.Telemetry,
      Budgeteer.Repo,
      {DNSCluster, query: Application.get_env(:budgeteer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Budgeteer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Budgeteer.Finch},
      # Start a worker by calling: Budgeteer.Worker.start_link(arg)
      # {Budgeteer.Worker, arg},
      # Start to serve requests, typically the last entry
      BudgeteerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Budgeteer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BudgeteerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
