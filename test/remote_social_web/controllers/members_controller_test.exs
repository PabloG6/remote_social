defmodule RemoteSocialWeb.MembersControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Account
  alias RemoteSocial.Account.Members
  alias RemoteSocial.Org

  @create_attrs %{
    email: "some email",
    name: "some name",
    password: "some password_hash"
  }
  @update_attrs %{
    email: "some updated email",
    name: "some updated name",
    password: "some updated password_hash"
  }
  @invalid_attrs %{email: nil, name: nil, password: nil}

  def fixture(:members) do
    {:ok, members} = Account.create_members(@create_attrs)
    members
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:dummy_company]
    test "lists all members", %{conn: conn} do
      conn = get(conn, Routes.members_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "signup members" do

    test "creates and generates token members when data is valid", %{conn: conn} do
      conn = post(conn, Routes.members_path(conn, :signup), members: @create_attrs)
      assert %{"member" => %{"id" => id}} = json_response(conn, 201)["data"]
      member = Account.get_members!(id)
      {:ok, token, _} = RemoteSocial.Auth.Guardian.encode_and_sign(member)
      conn = recycle(conn) |> put_req_header("authorization", "bearer: "<> token)
      conn = get(conn, Routes.members_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
               "name" => "some name",
               "password_hash" => password_hash
             } = json_response(conn, 200)["data"]

      assert Bcrypt.verify_pass("some password_hash", password_hash)
    end


    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.members_path(conn, :signup), members: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login members" do
    setup [:create_members]
    test "log in members when credentials are correct", %{conn: conn} do
      conn = post(conn, Routes.members_path(conn, :login), email: "some email", password: "some password_hash")
      assert %{
                "member" => %{
                    "id" => id,
                },
                "token" => token
              } = json_response(conn, 200)["data"]

      %Members{id: id_check} = RemoteSocial.Auth.Guardian.Plug.current_resource(conn)
      assert id_check == id

    end

    test "fail to log in members when credentials are incorrect", %{conn: conn} do
      conn = post(conn, Routes.members_path(conn, :login), email: "some email", password: "some wrong password")
      assert %{"message" => "Incorrect email or password", "code" => "incorrect_credentials"} = json_response(conn, 401)

      assert RemoteSocial.Auth.Guardian.Plug.current_resource(conn) == nil

    end


  end

  describe "update members" do
    setup [:create_members,:authenticate_members]

    test "renders members when data is valid and member is logged in", %{conn: conn, members: %Members{id: id} = members} do
      conn = put(conn, Routes.members_path(conn, :update, members), members: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.members_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some updated email",
               "name" => "some updated name",
               "password_hash" => password_hash
             } = json_response(conn, 200)["data"]

      assert Bcrypt.verify_pass("some updated password_hash", password_hash)
    end

    test "renders errors when data is invalid and member is logged in", %{conn: conn, members: members} do
      conn = put(conn, Routes.members_path(conn, :update, members), members: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete members" do
    setup [:create_members, :authenticate_members]

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

  defp authenticate_members(%{conn: conn, members: members}) do
    {:ok, token, _claims} = RemoteSocial.Auth.Guardian.encode_and_sign(members)
    conn = conn |> put_req_header("authorization", "bearer: " <> token)
    %{conn: conn}
  end

  defp dummy_company(%{conn: conn}) do
    {:ok, company} = Org.create_company(%{company_name: "some company name", company_tag: "some company tag", password: "some company password", email: "some company email"})
    {:ok, token, _claims} = RemoteSocial.Auth.Guardian.encode_and_sign(company)
    conn = conn |> put_req_header("authorization", "bearer: " <> token)
    %{conn: conn}
  end
end
