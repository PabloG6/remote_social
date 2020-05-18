defmodule RemoteSocialWeb.MembersControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Account
  alias RemoteSocial.Account.Members

  @create_attrs %{
    email: "some email",
    name: "some name",
    password_hash: "some password_hash"
  }
  @update_attrs %{
    email: "some updated email",
    name: "some updated name",
    password_hash: "some updated password_hash"
  }
  @invalid_attrs %{email: nil, name: nil, password_hash: nil}

  def fixture(:members) do
    {:ok, members} = Account.create_members(@create_attrs)
    members
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all members", %{conn: conn} do
      conn = get(conn, Routes.members_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create members" do
    test "renders members when data is valid", %{conn: conn} do
      conn = post(conn, Routes.members_path(conn, :create), members: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.members_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
               "name" => "some name",
               "password_hash" => "some password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.members_path(conn, :create), members: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update members" do
    setup [:create_members]

    test "renders members when data is valid", %{conn: conn, members: %Members{id: id} = members} do
      conn = put(conn, Routes.members_path(conn, :update, members), members: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.members_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some updated email",
               "name" => "some updated name",
               "password_hash" => "some updated password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, members: members} do
      conn = put(conn, Routes.members_path(conn, :update, members), members: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete members" do
    setup [:create_members]

    test "deletes chosen members", %{conn: conn, members: members} do
      conn = delete(conn, Routes.members_path(conn, :delete, members))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.members_path(conn, :show, members))
      end
    end
  end

  defp create_members(_) do
    members = fixture(:members)
    %{members: members}
  end
end
