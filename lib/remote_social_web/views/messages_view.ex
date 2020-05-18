defmodule RemoteSocialWeb.MessagesView do
  use RemoteSocialWeb, :view
  alias RemoteSocialWeb.MessagesView

  def render("index.json", %{message: message}) do
    %{data: render_many(message, MessagesView, "messages.json")}
  end

  def render("show.json", %{messages: messages}) do
    %{data: render_one(messages, MessagesView, "messages.json")}
  end

  def render("messages.json", %{messages: messages}) do
    %{id: messages.id,
      text: messages.text}
  end
end
