require 'net/http'

isbn = 9782264032980
url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}")
puts "ISBN #{isbn}, recherche de l'ID..."
req = Net::HTTP::Get.new(url.to_s)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = (url.scheme == "https")
res = http.request(req)
hash = JSON.parse(res.body)
id = hash["items"][0]["id"]

puts "ID : #{id}, recherche des données..."

url = URI.parse("https://www.googleapis.com/books/v1/volumes/#{id}")
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

puts "#{titre}, #{auteur}, Editions #{editeur}, #{nbPages} pages."

