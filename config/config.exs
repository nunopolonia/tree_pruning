# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tree_pruning,
  ecto_repos: [TreePruning.Repo]

# Configures the endpoint
config :tree_pruning, TreePruning.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: TreePruning.ErrorView, accepts: ~w(json)]

# Configures the database
config :tree_pruning, TreePruning.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DB_URL")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
