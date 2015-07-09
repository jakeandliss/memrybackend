json.extract! @show_tag, :id, :name
json.parent @show_tag.parent, :id, :name
json.children @show_tag.children, :id, :name
