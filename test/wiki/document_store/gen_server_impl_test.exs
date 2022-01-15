defmodule Wiki.DocumentStore.GenServerImplTest do
  use Wiki.DataCase

  alias Wiki.DocumentStore.GenServerImpl

  test "create/1" do
    assert {:ok, document} = GenServerImpl.create(title: "t", content: "c")
    assert document.id != nil
    assert document.title == "t"
    assert document.content == "c"
  end

  test "fetch_by_id/1" do
    assert {:ok, %{id: document_id}} = GenServerImpl.create(title: "t", content: "c")
    assert {:ok, document} = GenServerImpl.fetch_by_id(document_id)
    assert document.id == document_id
    assert %DateTime{} = document.inserted_at
    assert document.inserted_at == document.updated_at
  end

  test "fetch_all/1" do
    assert {:ok, %{id: document_id1}} = GenServerImpl.create(title: "t", content: "c")
    assert {:ok, %{id: document_id2}} = GenServerImpl.create(title: "i", content: "o")

    assert [%{id: ^document_id1}, %{id: ^document_id2}] =
             GenServerImpl.fetch_all(page_num: 1, per_page: 20)
  end

  test "get_total_count/0" do
    total_count = 30

    for x <- 1..total_count do
      assert {:ok, _} = GenServerImpl.create(title: "t_#{x}", content: "c_#{x}")
    end

    assert total_count == GenServerImpl.get_total_count()
  end
end
