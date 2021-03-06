defmodule RemoteSocial.AccountTest do
  use RemoteSocial.DataCase

  alias RemoteSocial.Account
  alias RemoteSocial.Org

  describe "members" do
    alias RemoteSocial.Account.Members

    @valid_attrs %{email: "some email", name: "some name", password: "some password_hash"}
    @update_attrs %{
      email: "some updated email",
      name: "some updated name",
      password: "some updated password hash"
    }
    @invalid_attrs %{email: nil, name: nil, password: nil}
    @company_attrs %{
      name: "some company name",
      tag: "some company tag",
      email: "some email",
      password: "some password hash"
    }
    def members_fixture(attrs \\ %{}) do
      {:ok, members} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_members()

      members
    end

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@company_attrs)
        |> Org.create_company()
        company
    end

    test "list_members/0 returns all members" do
      members = members_fixture()
      assert Account.list_members() == [%{members | password: nil}]
    end

    test "get_members!/1 returns the members with given id" do
      members = members_fixture()
      assert Account.get_members!(members.id) == %{members | password: nil}
    end

    test "create_members/1 with valid data creates a members" do
      assert {:ok, %Members{} = members} = Account.create_members(@valid_attrs)
      assert members.email == "some email"
      assert members.name == "some name"
      assert Bcrypt.verify_pass(members.password, members.password_hash)
    end

    test "create_members/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_members(@invalid_attrs)
    end

    test "update_members/2 with valid data updates the members" do
      members = members_fixture()
      assert {:ok, %Members{} = members} = Account.update_members(members, @update_attrs)
      assert members.email == "some updated email"
      assert members.name == "some updated name"
      assert Bcrypt.verify_pass("some updated password hash", members.password_hash)
    end

    test "update_members/2 with invalid data returns error changeset" do
      members = members_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_members(members, @invalid_attrs)
      assert %{members | password: nil} == Account.get_members!(members.id)
    end

    test "delete_members/1 deletes the members" do
      members = members_fixture()
      assert {:ok, %Members{}} = Account.delete_members(members)
      assert_raise Ecto.NoResultsError, fn -> Account.get_members!(members.id) end
    end

    test "change_members/1 returns a members changeset" do
      members = members_fixture()

      assert %Ecto.Changeset{} = Account.change_members(members)
    end

    @tag attach_company: true
    test "attach_company/2 associates a company with a member" do
      members = members_fixture()
      company = company_fixture()
      assert {:ok, %Account.Members{}} = Account.attach_company(company, members)
    end
  end
end
