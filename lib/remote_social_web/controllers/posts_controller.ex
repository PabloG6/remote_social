defmodule RemoteSocialWeb.PostsController do
  use RemoteSocialWeb, :controller

  alias RemoteSocial.Social
  alias RemoteSocial.Social.Posts

  action_fallback RemoteSocialWeb.FallbackController

  def index(conn, _params) do
    post = Social.list_post()
    render(conn, "index.json", post: post)
  end

  def create(conn, %{"posts" => posts_params}) do
    with {:ok, %Posts{} = posts} <- Social.create_posts(posts_params) do
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
end
