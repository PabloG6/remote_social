defmodule RemoteSocial.Auth.Guardian do
  use Guardian, otp_app: :remote_social

  alias RemoteSocial.Account

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Account.get_members!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
