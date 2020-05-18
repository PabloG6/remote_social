defmodule RemoteSocialWeb.MembersView do
  use RemoteSocialWeb, :view
  alias RemoteSocialWeb.MembersView

  def render("index.json", %{members: members}) do
    %{data: render_many(members, MembersView, "members.json")}
  end

  def render("show.json", %{members: members}) do
    %{data: render_one(members, MembersView, "members.json")}
  end

  def render("members.json", %{members: members}) do
    %{id: members.id,
      name: members.name,
      email: members.email,
      password_hash: members.password_hash}
  end


end
