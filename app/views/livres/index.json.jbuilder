json.array!(@livres) do |livre|
  json.extract! livre, :id, :titre, :auteur_id_id, :edition_id_id, :genre_id_id, :emplacement_id_id, :parution
  json.url livre_url(livre, format: :json)
end
