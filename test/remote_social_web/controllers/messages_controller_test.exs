defmodule RemoteSocialWeb.MessagesControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Social
  alias RemoteSocial.Social.Messages

  @create_attrs %{
    text: "some text"
  }
  @update_attrs %{
    text: "some updated text"
  }
  @invalid_attrs %{text: nil}

  def fixture(:messages) do
    {:ok, messages} = Social.create_messages(@create_attrs)
    messages
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all message", %{conn: conn} do
      conn = get(conn, Routes.messages_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create messages" do
    test "renders messages when data is valid", %{conn: conn} do
      conn = post(conn, Routes.messages_path(conn, :create), messages: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.messages_path(conn, :show, id))

      assert %{
               "id" => id,
               "text" => "some text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.messages_path(conn, :create), messages: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update messages" do
    setup [:create_messages]

    test "renders messages when data is valid", %{conn: conn, messages: %Messages{id: id} = messages} do
      conn = put(conn, Routes.messages_path(conn, :update, messages), messages: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.messages_path(conn, :show, id))

      assert %{
               "id" => id,
               "text" => "some updated text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, messages: messages} do
      conn = put(conn, Routes.messages_path(conn, :update, messages), messages: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete messages" do
    setup [:create_messages]

    test "deletes chosen messages", %{conn: conn, messages: messages} do
      conn = delete(conn, Routes.messages_path(conn, :delete, messages))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.messages_path(conn, :show, messages))
      end
    end
  end

  defp create_messages(_) do
    messages = fixture(:messages)
    %{messages: messages}
  end
end
