defmodule RemoteSocial.SocialTest do
  use RemoteSocial.DataCase

  alias RemoteSocial.Social

  describe "post" do
    alias RemoteSocial.Social.Posts
    alias RemoteSocial.Account
    @valid_attrs %{link: "some link", text: "some text"}
    @update_attrs %{link: "some updated link", text: "some updated text"}
    @invalid_attrs %{link: nil, text: nil}
    @member_attrs %{
      email: "some email",
      name: "some name",
      password: "some password_hash"
    }

    def posts_fixture(attrs \\ %{}) do
      member = members_fixture()
      post_attrs = attrs |> Enum.into(@valid_attrs)
      {:ok, posts} = Social.create_posts(member, post_attrs)
      posts
    end


    def members_fixture(attrs \\ %{}) do
      {:ok, members} =
        attrs
        |> Enum.into(@member_attrs)
        |> Account.create_members()

      members
    end

    test "list_post/0 returns all post" do
      posts = posts_fixture()
      assert Social.list_post() |> Enum.map(&(%{&1 | company: nil, author: nil})) == [posts] |>  Enum.map(&(%{&1 | company: nil, author: nil}))
    end

    test "get_posts!/1 returns the posts with given id" do
      posts = posts_fixture()
      assert %{Social.get_posts!(posts.id) | author: nil, company: nil} == %{posts | author: nil, company: nil}
    end

    test "create_posts/1 with valid data creates a posts" do
      member = members_fixture()
      assert {:ok, %Posts{} = posts} = Social.create_posts(member, @valid_attrs)
      assert posts.link == "some link"
      assert posts.text == "some text"
    end

    test "create_posts/1 with invalid data returns error changeset" do
      members = members_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.create_posts(members, @invalid_attrs)
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
      assert %{posts |author: nil, company: nil} == %{Social.get_posts!(posts.id) | author: nil, company: nil}
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
    alias RemoteSocial.Account
    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    # @sender_attrs %{
    #   email: "some email",
    #   name: "some name",
    #   password: "some password_hash"
    # }
    @recipient_attrs %{
      email: "some recipient email",
      name: "some recipient password",
      password: "some password_hash"
    }

    # def members_fixture(attrs \\ %{}) do
    #   {:ok, members} = attrs |> Enum.into(@sender_attrs) |> Account.create_members()
    #   members
    # end
    def messages_fixture(attrs \\ %{}) do
      member = members_fixture()
      recipient = members_fixture(@recipient_attrs)
      message = attrs |> Enum.into(@valid_attrs)
      {:ok, messages} = Social.create_messages(member, recipient, message)
      messages
    end

    test "list_message/0 returns all message" do
      messages = messages_fixture()
      assert Social.list_message() |>  Enum.map(&(%{&1 | recipient: nil, sender: nil})) ==
      [messages] |>  Enum.map(&(%{&1 | recipient: nil, sender: nil}))
    end

    test "get_messages!/1 returns the messages with given id" do
      messages = messages_fixture()
      assert %{Social.get_messages!(messages.id) | recipient: nil, sender: nil} == %{messages | recipient: nil, sender: nil}
    end

    test "create_messages/1 with valid data creates a messages" do
      member = members_fixture()
      recipient = members_fixture(@recipient_attrs)
      assert {:ok, %Messages{} = messages} = Social.create_messages(member, recipient,  @valid_attrs)
      assert messages.text == "some text"
    end

    test "create_messages/1 with invalid data returns error changeset" do
      member = members_fixture()
      recipient = members_fixture(@recipient_attrs)
      assert {:error, %Ecto.Changeset{}} = Social.create_messages(member, recipient, @invalid_attrs)
    end

    test "update_messages/2 with valid data updates the messages" do
      messages = messages_fixture()
      assert {:ok, %Messages{} = messages} = Social.update_messages(messages, @update_attrs)
      assert messages.text == "some updated text"
    end
    @tag modify_preload: true
    test "update_messages/2 with invalid data returns error changeset" do
      messages = messages_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_messages(messages, @invalid_attrs)

      assert %{messages | recipient: nil, sender: nil} == %{Social.get_messages!(messages.id) | recipient: nil, sender: nil}
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
