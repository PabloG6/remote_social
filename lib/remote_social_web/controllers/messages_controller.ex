defmodule RemoteSocialWeb.MessagesController do
  use RemoteSocialWeb, :controller

  alias RemoteSocial.Social
  alias RemoteSocial.Social.Messages

  action_fallback RemoteSocialWeb.FallbackController

  def index(conn, _params) do
    message = Social.list_message()
    render(conn, "index.json", message: message)
  end

  def create(conn, %{"messages" => messages_params}) do
    with {:ok, %Messages{} = messages} <- Social.create_messages(messages_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.messages_path(conn, :show, messages))
      |> render("show.json", messages: messages)
    end
  end

  def show(conn, %{"id" => id}) do
    messages = Social.get_messages!(id)
    render(conn, "show.json", messages: messages)
  end

  def update(conn, %{"id" => id, "messages" => messages_params}) do
    messages = Social.get_messages!(id)

    with {:ok, %Messages{} = messages} <- Social.update_messages(messages, messages_params) do
      render(conn, "show.json", messages: messages)
    end
  end

  def delete(conn, %{"id" => id}) do
    messages = Social.get_messages!(id)

    with {:ok, %Messages{}} <- Social.delete_messages(messages) do
      send_resp(conn, :no_content, "")
    end
  end
end
