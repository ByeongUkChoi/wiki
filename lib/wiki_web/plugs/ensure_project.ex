defmodule WikiWeb.Plugs.EnsureProject do
  @moduledoc false

  import Plug.Conn

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%{path_params: %{"project_id" => project_id}} = conn, _opts) do
    assign(conn, :project_id, project_id)
  end
end
