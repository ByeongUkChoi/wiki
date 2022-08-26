defmodule Wiki.Pages do
  def subscribe() do
    Phoenix.PubSub.subscribe(Wiki.PubSub, "pages")
  end

  def broadcast(event) do
    Phoenix.PubSub.broadcast(Wiki.PubSub, "pages", event)
  end
end
