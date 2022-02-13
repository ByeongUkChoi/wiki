defmodule WikiWeb.PageController do
  use WikiWeb, :controller

  alias Phoenix.LiveView
  alias WikiWeb.PageLive

  def index(conn, params) do
    id =
      case params do
        %{"id" => id} -> String.to_integer(id)
        _ -> nil
      end

    LiveView.Controller.live_render(conn, PageLive, session: %{"action" => :main, "id" => id})
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
