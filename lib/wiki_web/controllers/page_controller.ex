defmodule WikiWeb.PageController do
  use WikiWeb, :controller

  alias Phoenix.LiveView
  alias WikiWeb.PageLive

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, PageLive, session: %{"action" => :index})
  end

  def show(conn, _params) do
    LiveView.Controller.live_render(conn, PageLive, session: %{"action" => :show})
  end

  def new(conn, _params) do
    LiveView.Controller.live_render(conn, PageLive, session: %{"action" => :new})
  end
end
