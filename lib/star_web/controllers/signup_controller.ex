defmodule StarWeb.SignupController do
  use StarWeb, :controller
  alias Star.UserOperator
  @suscriptor_role "SUSCRIPTOR"

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_user(conn, params) do
    user = Star.SignupManager.create_user(params)
    render(conn, "success.html", user: user)
  end

  def suscribe(conn, params) do
    {_status, user} = UserOperator.create_user(params["email"], "", "", @suscriptor_role)

    render(conn, "suscriptor.html", user: user)
  end
end
