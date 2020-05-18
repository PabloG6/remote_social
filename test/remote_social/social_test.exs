defmodule RemoteSocial.SocialTest do
  use RemoteSocial.DataCase

  alias RemoteSocial.Social

  describe "post" do
    alias RemoteSocial.Social.Posts

    @valid_attrs %{link: "some link", text: "some text"}
    @update_attrs %{link: "some updated link", text: "some updated text"}
    @invalid_attrs %{link: nil, text: nil}

    def posts_fixture(attrs \\ %{}) do
      {:ok, posts} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_posts()

      posts
    end

    test "list_post/0 returns all post" do
      posts = posts_fixture()
      assert Social.list_post() == [posts]
    end

    test "get_posts!/1 returns the posts with given id" do
      posts = posts_fixture()
      assert Social.get_posts!(posts.id) == posts
    end

    test "create_posts/1 with valid data creates a posts" do
      assert {:ok, %Posts{} = posts} = Social.create_posts(@valid_attrs)
      assert posts.link == "some link"
      assert posts.text == "some text"
    end

    test "create_posts/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_posts(@invalid_attrs)
    end

    test "update_posts/2 with valid data updates the posts" do
      posts = posts_fixture()
      assert {:ok, %Posts{} = posts} = Social.update_posts(posts, @update_attrs)
      assert posts.link == "some updated link"
      assert posts.text == "some updated text"
    end

    test "update_posts/2 with invalid data returns error changeset" do
      posts = posts_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_posts(posts, @invalid_attrs)
      assert posts == Social.get_posts!(posts.id)
    end

    test "delete_posts/1 deletes the posts" do
      posts = posts_fixture()
      assert {:ok, %Posts{}} = Social.delete_posts(posts)
      assert_raise Ecto.NoResultsError, fn -> Social.get_posts!(posts.id) end
    end

    test "change_posts/1 returns a posts changeset" do
      posts = posts_fixture()
      assert %Ecto.Changeset{} = Social.change_posts(posts)
    end
  end

  describe "message" do
    alias RemoteSocial.Social.Messages

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def messages_fixture(attrs \\ %{}) do
      {:ok, messages} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_messages()

      messages
    end

    test "list_message/0 returns all message" do
      messages = messages_fixture()
      assert Social.list_message() == [messages]
    end

    test "get_messages!/1 returns the messages with given id" do
      messages = messages_fixture()
      assert Social.get_messages!(messages.id) == messages
    end

    test "create_messages/1 with valid data creates a messages" do
      assert {:ok, %Messages{} = messages} = Social.create_messages(@valid_attrs)
      assert messages.text == "some text"
    end

    test "create_messages/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_messages(@invalid_attrs)
    end

    test "update_messages/2 with valid data updates the messages" do
      messages = messages_fixture()
      assert {:ok, %Messages{} = messages} = Social.update_messages(messages, @update_attrs)
      assert messages.text == "some updated text"
    end

    test "update_messages/2 with invalid data returns error changeset" do
      messages = messages_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_messages(messages, @invalid_attrs)
      assert messages == Social.get_messages!(messages.id)
    end

    test "delete_messages/1 deletes the messages" do
      messages = messages_fixture()
      assert {:ok, %Messages{}} = Social.delete_messages(messages)
      assert_raise Ecto.NoResultsError, fn -> Social.get_messages!(messages.id) end
    end

    test "change_messages/1 returns a messages changeset" do
      messages = messages_fixture()
      assert %Ecto.Changeset{} = Social.change_messages(messages)
    end
  end
end
