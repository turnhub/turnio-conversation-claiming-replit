# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

config :conv_claim, ConvClaimWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [
    host: System.get_env("HOST", "0.0.0.0"),
    port: 443,
    scheme: "https"
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :conv_claim, ConvClaimWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

config :conv_claim, ConvClaim.TurnClient,
  turn_token: System.get_env("TURN_TOKEN", "turn-token"),
  turn_host: System.get_env("TURN_HOST", "https://turn.example.org")
