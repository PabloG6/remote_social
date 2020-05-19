defmodule RemoteSocialWeb.PostsController do
  use RemoteSocialWeb, :controller

  alias RemoteSocial.Social
  alias RemoteSocial.Social.Posts
  alias RemoteSocial.Auth
  alias Ecto
  action_fallback RemoteSocialWeb.FallbackController

  def index(conn, _params) do
    post = Social.list_post()
    render(conn, "index.json", post: post)
  end

  def create(conn, %{"posts" => posts_params}) do
    member = Auth.Guardian.Plug.current_resource(conn)
    with {:ok, %Posts{} = posts} <- Social.create_posts(member, posts_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.posts_path(conn, :show, posts))
      |> render("show.json", posts: posts)
    end
  end

  def show(conn, %{"id" => id}) do
    posts = Social.get_posts!(id)
    render(conn, "show.json", posts: posts)
  end

  def update(conn, %{"id" => id, "posts" => posts_params}) do

    posts = Social.get_posts!(id)

    with {:ok, %Posts{} = posts} <- Social.update_posts(posts, posts_params) do
      render(conn, "show.json", posts: posts)
    end
  end

  def delete(conn, %{"id" => id}) do
    posts = Social.get_posts!(id)

    with {:ok, %Posts{}} <- Social.delete_posts(posts) do
      send_resp(conn, :no_content, "")
    end
  end

  def list_feed(conn, _params) do
    member = Auth.Guardian.Plug.current_resource(conn)
    page = Social.list_feed(member)

    conn
    |> put_status(:ok)
    |> put_resp_content_type("application/json")
    |> render(:feed,
          posts: page.entries,
          page_number: page.page_number,
          total_pages: page.total_pages,
          total_entries: page.total_entries)
  end


end
