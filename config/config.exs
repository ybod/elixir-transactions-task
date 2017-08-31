# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :transactions_api,
  namespace: Transactions,
  ecto_repos: [Transactions.Repo]

# Configures the endpoint
config :transactions_api, TransactionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HSQ9nXbQtGtYRs1AMdVAs0afX2p8gb+TxyEV9HgtahqtVp+DbQuUeNnNIcuz45uT",
  render_errors: [view: TransactionsWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Transactions.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
