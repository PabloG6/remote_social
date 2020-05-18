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
end
