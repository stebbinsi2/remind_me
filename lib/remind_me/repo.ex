defmodule RemindMe.Repo do
  use Ecto.Repo,
    otp_app: :remind_me,
    adapter: Ecto.Adapters.Postgres
end
