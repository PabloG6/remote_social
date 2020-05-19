defmodule RemoteSocialWeb.PostsControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Social
  alias RemoteSocial.Social.Posts
  alias RemoteSocial.Account
  alias RemoteSocial.Auth
  @create_attrs %{
    link: "some link",
    text: "some text"
  }
  @update_attrs %{
    link: "some updated link",
    text: "some updated text"
  }


  @member_attrs %{
    email: "some email",
    name: "some name",
    password: "some password_hash"
  }
  @invalid_attrs %{link: nil, text: nil}

  def fixture(:posts) do
    {:ok, member} = Account.create_members(@member_attrs)
    {:ok, posts} = Social.create_posts(member, (@create_attrs)
    {member, posts}
  end

  setup %{conn: conn} do

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all post", %{conn: conn} do
      conn = get(conn, Routes.posts_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create posts" do
    test "renders posts when data is valid", %{conn: conn} do
      conn = post(conn, Routes.posts_path(conn, :create), posts: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

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
    setup [:create_posts]

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
    setup [:create_posts]

    test "deletes chosen posts", %{conn: conn, posts: posts} do
      conn = delete(conn, Routes.posts_path(conn, :delete, posts))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.posts_path(conn, :show, posts))
      end
    end
  end

  defp create_posts(%{conn: conn}) do
    {member, posts} = fixture(:posts)
    {:ok, token, _} = Auth.Guardian.Plug.current_resource(conn)
    conn = conn |> put_req_header("authorization", "bearer: "<> token)

    %{posts: posts, member: member}
  end
end
