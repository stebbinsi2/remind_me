defmodule RemindMe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RemindMeWeb.Telemetry,
      # Start the Ecto repository
      RemindMe.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: RemindMe.PubSub},
      # Start Finch
      {Finch, name: RemindMe.Finch},
      # Start the Endpoint (http/https)
      RemindMeWeb.Endpoint,
      # Start a worker by calling: RemindMe.Worker.start_link(arg)
      # {RemindMe.Worker, arg}
      {Oban, Application.fetch_env!(:remind_me, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RemindMe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RemindMeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
