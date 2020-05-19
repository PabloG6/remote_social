defmodule RemoteSocial.OrgTest do
  use RemoteSocial.DataCase

  alias RemoteSocial.Org

  describe "company" do
    alias RemoteSocial.Org.Company

    @valid_attrs %{
      company_name: "some company_name",
      company_tag: "some company_tag",
      email: "some email",
      password: "some password_hash"
    }
    @update_attrs %{
      company_name: "some updated company_name",
      company_tag: "some updated company_tag",
      email: "some updated email",
      password: "some updated password_hash"
    }
    @invalid_attrs %{name: nil, company_tag: nil, email: nil, password: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Org.create_company()

      company
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
      assert company.company_tag == "some company_tag"
      assert company.email == "some email"
      assert Bcrypt.verify_pass("some password_hash", company.password_hash)
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Org.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Org.update_company(company, @update_attrs)
      assert company.company_name == "some updated company_name"
      assert company.company_tag == "some updated company_tag"
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
  end
end
