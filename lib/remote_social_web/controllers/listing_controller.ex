defmodule RemoteSocialWeb.ListingController do
  use RemoteSocialWeb, :controller

  alias RemoteSocial.Jobs
  alias RemoteSocial.Jobs.Listing

  action_fallback RemoteSocialWeb.FallbackController

  def index(conn, _params) do
    listing = Jobs.list_listing()
    render(conn, "index.json", listing: listing)
  end

  def create(conn, %{"listing" => listing_params}) do
    with {:ok, %Listing{} = listing} <- Jobs.create_listing(listing_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.listing_path(conn, :show, listing))
      |> render("show.json", listing: listing)
    end
  end

  def show(conn, %{"id" => id}) do
    listing = Jobs.get_listing!(id)
    render(conn, "show.json", listing: listing)
  end

  def update(conn, %{"id" => id, "listing" => listing_params}) do
    listing = Jobs.get_listing!(id)

    with {:ok, %Listing{} = listing} <- Jobs.update_listing(listing, listing_params) do
      render(conn, "show.json", listing: listing)
    end
  end

  def delete(conn, %{"id" => id}) do
    listing = Jobs.get_listing!(id)

    with {:ok, %Listing{}} <- Jobs.delete_listing(listing) do
      send_resp(conn, :no_content, "")
    end
  end
end
