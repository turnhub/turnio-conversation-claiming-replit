# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :conv_claim, ConvClaimWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M/7jam3jJEEBvhUj5VmrYxJm7ihBuUsIQkghFte3SlGqP7Ikb/F8F2hTxRo8PVrB",
  render_errors: [view: ConvClaimWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ConvClaim.PubSub,
  live_view: [signing_salt: "KDiAMjPI"]

config :conv_claim, ConvClaim.TurnClient,
  turn_token: System.get_env("TURN_TOKEN", "turn-token"),
  turn_host: System.get_env("TURN_HOST", "https://turn.example.org")

config :tesla, :adapter, {Tesla.Adapter.Finch, name: ConvClaimFinch}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
