json.array!(@auteurs) do |auteur|
  json.extract! auteur, :id
  json.url auteur_url(auteur, format: :json)
end
