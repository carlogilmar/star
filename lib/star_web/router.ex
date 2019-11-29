defmodule StarWeb.Router do
  use StarWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {StarWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_pipeline do
    plug Star.Guardian.BrowserPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", StarWeb do
    pipe_through :browser
    get "/", PageController, :index

    ### Login for admin
    get "/home", LoginController, :index
    post "/login", LoginController, :login
    get "/logout", LoginController, :logout

    ### Create Users and Login
    get "/welcome", SignupController, :index
    post "/sign_up", SignupController, :create_user
    post "/suscribe", SignupController, :suscribe

  end

  ## Admin
  scope "/admin", StarWeb do
    pipe_through [:browser, :browser_pipeline, :ensure_auth]
    get "/", AdminController, :index
    live "/users", UsersLive
    live "/suscriptors", SuscriptorsLive
    get "/analytics", AnalyticsController, :index
  end

  ## Users
  scope "/user", StarWeb do
    pipe_through [:browser, :browser_pipeline, :ensure_auth]
    get "/", UserController, :index
  end
end
