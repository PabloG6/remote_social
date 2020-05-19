defmodule RemoteSocialWeb.CompanyControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Org
  alias RemoteSocial.Org.Company
  alias RemoteSocial.Account

  @create_attrs %{
    name: "some name",
    tag: "some company_tag",
    email: "some email",
    password: "some password_hash"
  }
  @update_attrs %{
    name: "some updated name",
    tag: "some updated company_tag",
    email: "some updated email",
    password: "some updated password_hash"
  }
  @invalid_attrs %{name: nil, tag: nil, email: nil, password: nil}

  def fixture(:company) do
    {:ok, company} = Org.create_company(@create_attrs)
    company
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:dummy_member]

    test "lists all company", %{conn: conn} do
      conn = get(conn, Routes.company_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "signup company" do
    test "renders company when data is valid", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :signup), company: @create_attrs)
      assert %{"company" => %{"id" => id}} = json_response(conn, 201)["data"]
      company = Org.get_company!(id)
      {:ok, token, _claims} = RemoteSocial.Auth.Guardian.encode_and_sign(company)
      conn = recycle(conn) |> put_req_header("authorization", "bearer: " <> token)
      conn = get(conn, Routes.company_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "tag" => "some company_tag",
               "email" => "some email",
               "password_hash" => password_hash
             } = json_response(conn, 200)["data"]

      assert Bcrypt.verify_pass("some password_hash", password_hash)


    end

    test "signup user with invalid information", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :signup), company: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login members" do
    setup [:create_company]
    test "log in members when credentials are correct", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :login), email: "some email", password: "some password_hash")
      assert %{
                "company" => %{
                    "id" => id,
                },
                "token" => token
              } = json_response(conn, 200)["data"]

      %Company{id: id_check} = RemoteSocial.Auth.Guardian.Plug.current_resource(conn)
      assert id_check == id

    end

    test "fail to log in members when credentials are incorrect", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :login), email: "some email", password: "some wrong password")
      assert %{"message" => "Incorrect email or password", "code" => "incorrect_credentials"} = json_response(conn, 401)

      assert RemoteSocial.Auth.Guardian.Plug.current_resource(conn) == nil

    end
  end

  describe "update company" do
    setup [:create_company, :authenticate_company]

    test "renders company when data is valid", %{conn: conn, company: %Company{id: id} = company} do
      conn = put(conn, Routes.company_path(conn, :update, company), company: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.company_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "tag" => "some updated company_tag",
               "email" => "some updated email",
               "password_hash" => password_hash
             } = json_response(conn, 200)["data"]

      assert Bcrypt.verify_pass("some updated password_hash", password_hash)
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn = put(conn, Routes.company_path(conn, :update, company), company: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete company" do
    setup [:create_company, :authenticate_company]

    test "deletes chosen company", %{conn: conn, company: company} do
      conn = delete(conn, Routes.company_path(conn, :delete, company))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.company_path(conn, :show, company))
      end
    end
  end

  defp create_company(_) do
    company = fixture(:company)
    %{company: company}
  end

  defp authenticate_company(%{conn: conn, company: company}) do
    {:ok, token, _claims} = RemoteSocial.Auth.Guardian.encode_and_sign(company)
    conn = conn |> put_req_header("authorization", "bearer: " <> token)
    %{conn: conn}
  end

  defp dummy_member(%{conn: conn}) do
    {:ok, member} =
      Account.create_members(%{name: "some name", password: "some password", email: "some email"})

    {:ok, token, _claims} = RemoteSocial.Auth.Guardian.encode_and_sign(member)
    conn = conn |> put_req_header("authorization", "bearer: " <> token)
    %{conn: conn}
  end
end
