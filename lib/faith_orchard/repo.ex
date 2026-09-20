defmodule FaithOrchard.Repo do
  use Ecto.Repo,
    otp_app: :faith_orchard,
    adapter: Ecto.Adapters.Postgres
end
