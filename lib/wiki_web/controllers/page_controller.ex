defmodule WikiWeb.PageController do
  use WikiWeb, :controller

  alias Phoenix.LiveView
  alias WikiWeb.PageLive

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, PageLive, [])
  end
end
