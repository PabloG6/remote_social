defmodule RemoteSocialWeb.PostsControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Social
  alias RemoteSocial.Social.Posts
  alias RemoteSocial.Account
  alias RemoteSocial.Auth
  alias RemoteSocial.Org
  @create_attrs %{
    link: "some link",
    text: "some text"
  }
  @update_attrs %{
    link: "some updated link",
    text: "some updated text"
  }


  @members_attrs %{
    email: "some email",
    name: "some name",
    password: "some password_hash"
  }

  @company_attrs %{
    email: "some company email",
    tag: "some company tag",
    name: "some company name",
    password: "some company password"
  }
  @invalid_attrs %{link: nil, text: nil}

  def fixture(member) do
    {:ok, posts} = Social.create_posts(member, @create_attrs)
    posts
  end

  def members_fixture() do
    {:ok, member} = Account.create_members(@members_attrs)
    member
  end

  def company_fixture(attrs \\ %{}) do
    {:ok, company} = attrs |> Enum.into(@company_attrs) |> Org.create_company()
    company
  end
  setup %{conn: conn} do

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_member, :authenticate_member]
    test "lists all post", %{conn: conn} do
      conn = get(conn, Routes.posts_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create posts" do
    setup [:create_member, :authenticate_member]
    test "renders posts when data is valid", %{conn: conn, token: token} do
      conn = post(conn, Routes.posts_path(conn, :create), posts: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = recycle(conn) |> put_req_header("authorization", "bearer: " <> token)
      conn = get(conn, Routes.posts_path(conn, :show, id))

      assert %{
               "id" => id,
               "link" => "some link",
               "text" => "some text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.posts_path(conn, :create), posts: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update posts" do
    setup [:create_member, :authenticate_member, :create_posts]

    test "renders posts when data is valid", %{conn: conn, posts: %Posts{id: id} = posts} do
      conn = put(conn, Routes.posts_path(conn, :update, posts), posts: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.posts_path(conn, :show, id))

      assert %{
               "id" => id,
               "link" => "some updated link",
               "text" => "some updated text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, posts: posts} do
      conn = put(conn, Routes.posts_path(conn, :update, posts), posts: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete posts" do
    setup [:create_member, :authenticate_member, :create_posts, :create_company, :attach_member]

    test "deletes chosen posts", %{conn: conn, posts: posts} do
      conn = delete(conn, Routes.posts_path(conn, :delete, posts))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.posts_path(conn, :show, posts))
      end
    end
  end

  defp create_company(_) do
    company = company_fixture()
    %{company: company}
  end

  defp create_member(_) do
    member = members_fixture()
    %{member: member}
  end

  #for now let create post also add_member/2 because users get posts based on their company.
  defp create_posts(%{member: member}) do

    posts = fixture(member)
    %{posts: posts}
  end

  defp attach_member(%{member: member, company: company} = conn) do
    {:ok, _} = Org.add_member(company, member)
    conn
  end

  defp authenticate_member(%{conn: conn, member: member}) do
    {:ok, token, _} = Auth.Guardian.encode_and_sign(member)
    conn = conn |> put_req_header("authorization", "bearer: "<> token)
    %{conn: conn, token: token}
  end

end
