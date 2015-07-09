json.extract! @tag, :id, :name
json.parent @tag.parent, :id, :name if @tag.parent
json.children @tag.children , :id, :name if @tag.children
