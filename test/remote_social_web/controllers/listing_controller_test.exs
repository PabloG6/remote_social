defmodule RemoteSocialWeb.ListingControllerTest do
  use RemoteSocialWeb.ConnCase

  alias RemoteSocial.Jobs
  alias RemoteSocial.Jobs.Listing

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:listing) do
    {:ok, listing} = Jobs.create_listing(@create_attrs)
    listing
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all listing", %{conn: conn} do
      conn = get(conn, Routes.listing_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create listing" do
    test "renders listing when data is valid", %{conn: conn} do
      conn = post(conn, Routes.listing_path(conn, :create), listing: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.listing_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.listing_path(conn, :create), listing: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update listing" do
    setup [:create_listing]

    test "renders listing when data is valid", %{conn: conn, listing: %Listing{id: id} = listing} do
      conn = put(conn, Routes.listing_path(conn, :update, listing), listing: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.listing_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, listing: listing} do
      conn = put(conn, Routes.listing_path(conn, :update, listing), listing: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete listing" do
    setup [:create_listing]

    test "deletes chosen listing", %{conn: conn, listing: listing} do
      conn = delete(conn, Routes.listing_path(conn, :delete, listing))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.listing_path(conn, :show, listing))
      end
    end
  end

  defp create_listing(_) do
    listing = fixture(:listing)
    %{listing: listing}
  end
end
