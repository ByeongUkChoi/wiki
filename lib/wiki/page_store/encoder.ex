defprotocol Mongo.Encoder do
  @fallback_to_any false

  @spec encode(t) :: map()
  def encode(value)
end

defimpl Mongo.Encoder, for: Wiki.PageStore.Page do
  def encode(%{id: id, title: title, content: content, parent_id: parent_id}) do
    %{
      _id: id,
      title: title,
      content: content,
      parent_id: parent_id,
      custom_encoded: true
    }
  end
end
