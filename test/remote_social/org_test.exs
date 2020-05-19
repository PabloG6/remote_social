defmodule RemoteSocial.OrgTest do
  use RemoteSocial.DataCase

  alias RemoteSocial.Org
  alias RemoteSocial.Account

  describe "company" do
    alias RemoteSocial.Org.Company

    @valid_attrs %{
      name: "some company_name",
      tag: "some company_tag",
      email: "some email",
      password: "some password_hash"
    }
    @update_attrs %{
      name: "some updated company_name",
      tag: "some updated company_tag",
      email: "some updated email",
      password: "some updated password_hash"
    }
    @invalid_attrs %{name: nil, tag: nil, email: nil, password: nil}

    @members_attrs %{
      email: "some email",
      name: "some name",
      password: "some password_hash"
    }
    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Org.create_company()

      company
    end

    def members_fixture(attrs \\ %{}) do
      {:ok, members} =
        attrs
        |> Enum.into(@members_attrs)
        |> Account.create_members()

      members
    end

    test "list_company/0 returns all company" do
      company = company_fixture()
      assert Org.list_company() == [%{company | password: nil}]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert %{Org.get_company!(company.id) | password: nil} == %{company | password: nil}
    end

    test "get_company_by/1 returns the company when given certain params" do
      _company = company_fixture()
      assert {:ok, _company} = Org.get_company_by(email: "some email")
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Org.create_company(@valid_attrs)
      assert company.name == "some company_name"
      assert company.tag == "some company_tag"
      assert company.email == "some email"
      assert Bcrypt.verify_pass("some password_hash", company.password_hash)
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Org.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Org.update_company(company, @update_attrs)
      assert company.name == "some updated company_name"
      assert company.tag == "some updated company_tag"
      assert company.email == "some updated email"
      assert Bcrypt.verify_pass("some updated password_hash", company.password_hash)
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Org.update_company(company, @invalid_attrs)
      assert %{company | password: nil} == Org.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Org.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Org.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Org.change_company(company)
    end

    @tag attach_company: true
    test "add_member/2 associates a company to a member" do
      company = company_fixture()
      members = members_fixture()
      assert {:ok, company} = Org.add_member(company, members)
    end
  end
end
