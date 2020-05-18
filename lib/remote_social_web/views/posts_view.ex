defmodule RemoteSocialWeb.PostsView do
  use RemoteSocialWeb, :view
  alias RemoteSocialWeb.PostsView

  def render("index.json", %{post: post}) do
    %{data: render_many(post, PostsView, "posts.json")}
  end

  def render("show.json", %{posts: posts}) do
    %{data: render_one(posts, PostsView, "posts.json")}
  end

  def render("posts.json", %{posts: posts}) do
    %{id: posts.id,
      text: posts.text,
      link: posts.link}
  end
end
