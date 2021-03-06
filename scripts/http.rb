require 'net/http'

isbn = 9782264032980
url = URI.parse("https://www.googleapis.com/books/v1/volumes?country=FR&q=isbn:#{isbn}")
puts "ISBN #{isbn}, recherche de l'ID..."
req = Net::HTTP::Get.new(url.to_s)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = (url.scheme == "https")
res = http.request(req)
hash = JSON.parse(res.body)
id = hash["items"][0]["id"]

puts "ID : #{id}, recherche des données..."

url = URI.parse("https://www.googleapis.com/books/v1/volumes/#{id}?country=FR")
req = Net::HTTP::Get.new(url.to_s)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = (url.scheme == "https")
res = http.request(req)
hash = JSON.parse(res.body)
datas = hash["volumeInfo"]
titre_str = datas["title"]
auteur_str = datas["authors"][0]
editeur_str = datas["publisher"]
nbPages = datas["pageCount"].to_i
description = datas["description"]

puts "#{titre_str}, #{auteur_str}, Editions #{editeur_str}, #{nbPages} pages."


auteur = Auteur.where("LOWER(nom) like LOWER(#{auteur_str})")
if auteur.empty?
  auteur = Auteur.create({nom: auteur_str})
else
  auteur = auteur.first
end
edition = Edition.where("LOWER(nom) like LOWER(#{auteur_str})")
if edition.empty?
  edition = Edition.create({nom: auteur_str})
else
  edition = edition.first
end
livre = Livre.where("LOWER(titre) like LOWER(#{titre_str})")
if livre.nil?
  livre = Livre.create({titre: titre_str, nb_pages: nbPages, description: description, auteur: auteur, edition: edition})
else
  livre = livre.first
end
