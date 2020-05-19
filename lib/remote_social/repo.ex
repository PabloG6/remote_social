defmodule RemoteSocial.Repo do
  use Ecto.Repo,
    otp_app: :remote_social,
    adapter: Ecto.Adapters.Postgres
    use Scrivener, page_size: 150

end
