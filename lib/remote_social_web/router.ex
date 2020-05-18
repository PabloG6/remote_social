defmodule RemoteSocialWeb.Router do
  use RemoteSocialWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug RemoteSocial.Auth.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :cors do
  end

  scope "/api", RemoteSocialWeb do
    pipe_through [:api, :auth]
    resources "/company", CompanyController, [:new, :edit, :create]
    resources "/members", MembersController, [:new, :edit, :create]
  end

  # CompanyController scope functions that may not need authentication to function.

  scope "/api", RemoteSocialWeb do
    pipe_through :api
    post "/company/signup", CompanyController, :signup
    post "/company/login", CompanyController, :login
  end

  scope "/api", RemoteSocialWeb do
    pipe_through :api
    post "/members/signup", MembersController, :signup
    post "/members/login", MembersController, :login
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: RemoteSocialWeb.Telemetry
    end
  end
end
