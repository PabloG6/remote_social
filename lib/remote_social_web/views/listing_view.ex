defmodule RemoteSocialWeb.ListingView do
  use RemoteSocialWeb, :view
  alias RemoteSocialWeb.ListingView

  def render("index.json", %{listing: listing}) do
    %{data: render_many(listing, ListingView, "listing.json")}
  end

  def render("show.json", %{listing: listing}) do
    %{data: render_one(listing, ListingView, "listing.json")}
  end

  def render("listing.json", %{listing: listing}) do
    %{id: listing.id}
  end
end
