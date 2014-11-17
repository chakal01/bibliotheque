json.array!(@editions) do |edition|
  json.extract! edition, :id
  json.url edition_url(edition, format: :json)
end
