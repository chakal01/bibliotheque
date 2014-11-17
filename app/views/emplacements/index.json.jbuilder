json.array!(@emplacements) do |emplacement|
  json.extract! emplacement, :id
  json.url emplacement_url(emplacement, format: :json)
end
