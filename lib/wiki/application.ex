defmodule Wiki.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start mongo db connection
      {Mongo, [name: :mongo, database: "wiki", pool_size: 2]},
      # Start the Telemetry supervisor
      WikiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Wiki.PubSub},
      # Start the Endpoint (http/https)
      WikiWeb.Endpoint,
      # Start a worker by calling: Wiki.Worker.start_link(arg)
      Wiki.Registry
      # {Wiki.Worker, arg}
      # data store
      # {Wiki.PageStore.GenServerImpl, %{}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wiki.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WikiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
