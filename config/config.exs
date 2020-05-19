# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :remote_social,
  ecto_repos: [RemoteSocial.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :remote_social, RemoteSocialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EHGkEmSHGMvUkUelVWJJAirFEEtx462qL+GWAZ6wvuHPQ8yuRntiUdbKW76fhnAY",
  render_errors: [view: RemoteSocialWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: RemoteSocial.PubSub,
  live_view: [signing_salt: "WorJQa/D"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :remote_social, RemoteSocial.Auth.Guardian,
  secret_key: "9pk1PvjLaEWniWYTFWpcYyiSbhyoU/XAN3qxfA27qy/F22gCRtMJmD+r4AmRrMs6",
  issuer: "remote_social"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :bcrypt_elixir, log_rounds: 4
config :remote_social, RemoteSocial.Repo, migration_timestamps: [type: :utc_datetime]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
