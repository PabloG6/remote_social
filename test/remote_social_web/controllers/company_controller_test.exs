defmodule RemoteSocialWeb.CompanyControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Org
  alias RemoteSocial.Org.Company

  @create_attrs %{
    company_name: "some company_name",
    company_tag: "some company_tag",
    email: "some email",
    password: "some password_hash"
  }
  @update_attrs %{
    company_name: "some updated company_name",
    company_tag: "some updated company_tag",
    email: "some updated email",
    password: "some updated password_hash"
  }
  @invalid_attrs %{company_name: nil, company_tag: nil, email: nil, password: nil}

  def fixture(:company) do
    {:ok, company} = Org.create_company(@create_attrs)
    company
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all company", %{conn: conn} do
      conn = get(conn, Routes.company_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create company" do
    test "renders company when data is valid", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :create), company: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.company_path(conn, :show, id))

      assert %{
               "id" => id,
               "company_name" => "some company_name",
               "company_tag" => "some company_tag",
               "email" => "some email",
               "password_hash" => password_hash
             } = json_response(conn, 200)["data"]
      assert Bcrypt.verify_pass("some password_hash", password_hash)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :create), company: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update company" do
    setup [:create_company]

    test "renders company when data is valid", %{conn: conn, company: %Company{id: id} = company} do
      conn = put(conn, Routes.company_path(conn, :update, company), company: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.company_path(conn, :show, id))

      assert %{
               "id" => id,
               "company_name" => "some updated company_name",
               "company_tag" => "some updated company_tag",
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
    setup [:create_company]

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
end
