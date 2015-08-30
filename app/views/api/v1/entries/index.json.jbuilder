json.entries @entries do | entry|
  json.partial! "entry_with_resources", entry: entry
end
