defmodule Wiki.PageEvent do
  def subscribe() do
    Phoenix.PubSub.subscribe(Wiki.PubSub, "pages")
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(Wiki.PubSub, "pages:#{id}")
  end

  def broadcast(id, event) do
    Phoenix.PubSub.broadcast(Wiki.PubSub, "pages:#{id}", event)
  end

  def broadcast(event) do
    Phoenix.PubSub.broadcast(Wiki.PubSub, "pages", event)
  end
end
