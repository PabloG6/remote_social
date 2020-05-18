defmodule RemoteSocialWeb.MembersController do
  use RemoteSocialWeb, :controller

  alias RemoteSocial.Account
  alias RemoteSocial.Account.Members

  action_fallback RemoteSocialWeb.FallbackController

  def index(conn, _params) do
    members = Account.list_members()
    render(conn, "index.json", members: members)
  end

  def create(conn, %{"members" => members_params}) do
    with {:ok, %Members{} = members} <- Account.create_members(members_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.members_path(conn, :show, members))
      |> render("show.json", members: members)
    end
  end

  def show(conn, %{"id" => id}) do
    members = Account.get_members!(id)
    render(conn, "show.json", members: members)
  end

  def update(conn, %{"id" => id, "members" => members_params}) do
    members = Account.get_members!(id)

    with {:ok, %Members{} = members} <- Account.update_members(members, members_params) do
      render(conn, "show.json", members: members)
    end
  end

  def delete(conn, %{"id" => id}) do
    members = Account.get_members!(id)

    with {:ok, %Members{}} <- Account.delete_members(members) do
      send_resp(conn, :no_content, "")
    end
  end

  def signup(conn, %{"members" => member_params}) do
    with {:ok, %Members{} = company} <- Account.create_members(member_params) do
      conn
      |> put_status(:created)
      |> authenticate_member(company)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %Members{} = company} <- Account.get_members_by(email: email) do
      conn
      |> put_status(:ok)
      |> authenticate_member(%{company | password: password})
    end
  end

  defp authenticate_member(conn, %Members{} = member) do
    with {:ok, member} <- Account.authenticate_members(member),
         conn <- RemoteSocial.Auth.Guardian.Plug.sign_in(conn, member),
         token <- RemoteSocial.Auth.Guardian.Plug.current_token(conn) do
      conn
      |> put_view(RemoteSocialWeb.MembersView)
      |> render("login.json", members: member, token: token)
    else
      {:error, :invalid_credentials} ->
        conn
        |> put_resp_content_type("application/json")
        |> resp(401, Poison.encode!(%{message: "Incorrect email or password", code: :incorrect_credentials}))
        |> send_resp()

      error ->
        error
    end
  end
end
