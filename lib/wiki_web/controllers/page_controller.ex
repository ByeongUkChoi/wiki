defmodule WikiWeb.PageController do
  use WikiWeb, :controller

  alias Phoenix.LiveView
  alias WikiWeb.PageLive

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, PageLive, session: %{"action" => :main})
  end

  def show(conn, %{"id" => id}) do
    LiveView.Controller.live_render(conn, PageLive,
      session: %{"action" => :show, "id" => String.to_integer(id)}
    )
  end

  def new(conn, _params) do
    LiveView.Controller.live_render(conn, PageLive, session: %{"action" => :new})
  end
end
