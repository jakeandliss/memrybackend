json.extract! @show_tag, :id, :name
json.parent @show_tag.parent, :id, :name if @show_tag.parent
json.children @show_tag.children , :id, :name if @show_tag.children
