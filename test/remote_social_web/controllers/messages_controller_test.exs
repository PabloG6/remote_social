defmodule RemoteSocialWeb.MessagesControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Social
  alias RemoteSocial.Social.Messages
  alias RemoteSocial.Auth
  alias RemoteSocial.Account
  @create_attrs %{
    text: "some text"
  }
  @update_attrs %{
    text: "some updated text"
  }
  @invalid_attrs %{text: nil}

  @member_attrs %{
    email: "some email",
    name: "some name",
    password: "some password_hash"
  }

  @recipient_attrs %{
    email: "some recipient email",
    name: "some recipient name",
    password: "some password_hash"
  }
  def member_fixture(attrs \\ %{}) do
    {:ok, member} = attrs |> Enum.into(@member_attrs) |> Account.create_members()
    member
  end

  def recipient_fixture(attrs \\ %{}) do
    {:ok, recipient} = attrs |> Enum.into(@recipient_attrs) |> Account.create_members()
    recipient
  end
  def fixture(:messages) do
    recipient = recipient_fixture()
    member =  member_fixture()
    {:ok, messages} = Social.create_messages(member, recipient, @create_attrs)
    {member, recipient, messages}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_member, :authenticate_member]
    test "lists all message", %{conn: conn} do
      conn = get(conn, Routes.messages_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create messages" do
    setup [:create_member, :authenticate_member, :create_recipient]
    test "renders messages when data is valid", %{conn: conn, recipient: recipient} do
      conn = post(conn, Routes.messages_path(conn, :create), messages: @create_attrs, recipient_id: recipient.id)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.messages_path(conn, :show, id))

      assert %{
               "id" => id,
               "text" => "some text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, recipient: recipient} do
      conn = post(conn, Routes.messages_path(conn, :create), messages: @invalid_attrs, recipient_id: recipient.id)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end


  describe "delete messages" do
    setup [:create_messages, :authenticate_member]

    test "deletes chosen messages", %{conn: conn, messages: messages} do
      conn = delete(conn, Routes.messages_path(conn, :delete, messages))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.messages_path(conn, :show, messages))
      end
    end
  end

  defp create_member(_) do
    member = member_fixture()
    %{member: member}
  end

  defp create_recipient(_) do
    recipient = recipient_fixture()
    %{recipient: recipient}
  end

  defp authenticate_member(%{conn: conn, member: member}) do
    {:ok, token, _} = Auth.Guardian.encode_and_sign(member)
    conn = conn |> put_req_header("authorization", "bearer: "<> token)
    %{conn: conn, token: token}
  end

  defp create_messages(_) do
    {sender, recipient, messages} = fixture(:messages)
    %{messages: messages, member: sender, recipient: recipient}
  end
end
