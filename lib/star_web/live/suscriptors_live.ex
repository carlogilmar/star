defmodule StarWeb.SuscriptorsLive do
  use Phoenix.LiveView
  alias Star.UserOperator
  alias StarWeb.SuscriptorsView

  def render(assigns) do
    SuscriptorsView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    socket = update_users(socket)
    {:ok, socket}
  end

  def handle_event("redirect_url", %{"uri_val" => uri_val}, socket) do
    {:noreply, live_redirect(socket, to: uri_val)}
  end

  def handle_event("delete", %{"user_id" => user_id}, socket) do
    user_id = String.to_integer(user_id)
    {:ok, _user_deleted} = UserOperator.delete_user(user_id)
    socket = update_users(socket)
    {:noreply, socket}
  end

  defp update_users(socket) do
    users = UserOperator.get_all_by_role("SUSCRIPTOR")

    socket
    |> assign(:users, users)
    |> assign(:total, length(users))
  end

end
