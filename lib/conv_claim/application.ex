defmodule ConvClaim.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ConvClaimWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ConvClaim.PubSub},
      # Start the Endpoint (http/https)
      ConvClaimWeb.Endpoint,
      # Start a worker by calling: ConvClaim.Worker.start_link(arg)
      # {ConvClaim.Worker, arg},
      {Finch,
       name: ConvClaimFinch,
       pools: %{
         # Cloud run's configured at 80 maximum concurrent connections
         # setting it to 160 should be plenty
         :default => [size: 160]
       }}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConvClaim.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConvClaimWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
