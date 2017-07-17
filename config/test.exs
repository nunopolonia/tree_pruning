use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tree_pruning, TreePruning.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :tree_pruning,
  http_lib: FakeHTTPoison

# Configure your database
config :tree_pruning, TreePruning.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  url: "#{System.get_env("DB_URL")}-test"