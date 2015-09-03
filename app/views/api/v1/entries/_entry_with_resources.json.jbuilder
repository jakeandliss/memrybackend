json.(entry, :id, :title, :content)

json.resources entry.resources do | resource|
  json.file_name resource.attachment_file_name
  json.file_path resource.attachment.path
end
