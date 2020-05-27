defmodule RemoteSocial.JobsTest do
  use RemoteSocial.DataCase

  alias RemoteSocial.Jobs

  describe "listing" do
    alias RemoteSocial.Jobs.Listing

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def listing_fixture(attrs \\ %{}) do
      {:ok, listing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Jobs.create_listing()

      listing
    end

    test "list_listing/0 returns all listing" do
      listing = listing_fixture()
      assert Jobs.list_listing() == [listing]
    end

    test "get_listing!/1 returns the listing with given id" do
      listing = listing_fixture()
      assert Jobs.get_listing!(listing.id) == listing
    end

    test "create_listing/1 with valid data creates a listing" do
      assert {:ok, %Listing{} = listing} = Jobs.create_listing(@valid_attrs)
    end

    test "create_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_listing(@invalid_attrs)
    end

    test "update_listing/2 with valid data updates the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{} = listing} = Jobs.update_listing(listing, @update_attrs)
    end

    test "update_listing/2 with invalid data returns error changeset" do
      listing = listing_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_listing(listing, @invalid_attrs)
      assert listing == Jobs.get_listing!(listing.id)
    end

    test "delete_listing/1 deletes the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{}} = Jobs.delete_listing(listing)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_listing!(listing.id) end
    end

    test "change_listing/1 returns a listing changeset" do
      listing = listing_fixture()
      assert %Ecto.Changeset{} = Jobs.change_listing(listing)
    end
  end
end
