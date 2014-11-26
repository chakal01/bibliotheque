# encoding: UTF-8
require 'net/http'

EventMachine.run do
  puts "Ready ! on #{Rails.application.config.ipadress}:#{Rails.application.config.port}"
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(host: Rails.application.config.ipadress, port: Rails.application.config.port, debug: false) do |ws|
    ws.onopen do
      sid = @channel.subscribe { |msg| ws.send(msg) }
      # @channel.push({class: "info", content: "#{sid} connected"}.to_json)
    

    ws.onmessage do |msg|
      isbn = msg

      # puts "ISBN #{isbn}, recherche de l'ID..."
      @channel.push({class: "info", content: "ISBN #{isbn}, recherche de l'ID..."}.to_json)


      url = URI.parse("https://www.googleapis.com/books/v1/volumes?country=FR&q=isbn:#{isbn}")
      req = Net::HTTP::Get.new(url.to_s)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")
      res = http.request(req)
      hash = JSON.parse(res.body)
      if hash["totalItems"] > 0
        id = hash["items"][0]["id"]

        @channel.push({class: "info", content: "ID : #{id}, recherche des données..."}.to_json)

        url = URI.parse("https://www.googleapis.com/books/v1/volumes/#{id}?country=FR")
        req = Net::HTTP::Get.new(url.to_s)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == "https")
        res = http.request(req)
        hash = JSON.parse(res.body)
        datas = hash["volumeInfo"]
        titre_str = datas["title"]
        auteur_str = datas["authors"][0]
        edition_str = datas["publisher"]
        nbPages = datas["pageCount"].to_i
        description = datas["description"]

        @channel.push({class: "info", content: "#{titre_str}, #{auteur_str}, Editions #{edition_str}, #{nbPages} pages."}.to_json)

        auteur = Auteur.where("LOWER(nom) like LOWER(#{ActiveRecord::Base.connection.quote(auteur_str)})")
        if auteur.empty?
          auteur = Auteur.create({nom: auteur_str})
          @channel.push({class: "success", content: "Ajout de l\'auteur #{auteur_str} &agrave; la base."}.to_json)
        else
          auteur = auteur.first
          @channel.push({class: "info", content: "L\'auteur #{auteur_str} existe d&eacute;j&agrave;."}.to_json)
        end
        edition = Edition.where("LOWER(nom) like LOWER(#{ActiveRecord::Base.connection.quote(edition_str)})")
        if edition.empty?
          edition = Edition.create({nom: edition_str})
          @channel.push({class: "success", content: "Ajout de l\'&eacute;dition #{edition_str} &agrave; la base."}.to_json)
        else
          edition = edition.first
          @channel.push({class: "info", content: "L\'&eacute;dition #{edition_str} existe d&eacute;j&agrave;."}.to_json)
        end
        livre = Livre.where("LOWER(titre) like LOWER(#{ActiveRecord::Base.connection.quote(titre_str)})")
        if livre.empty?
          livre = Livre.create({titre: titre_str, nb_pages: nbPages, description: description, auteur_id: auteur.id, edition_id: edition.id})
          @channel.push({class: "success", content: "Ajout du livre #{titre_str} &agrave; la base."}.to_json)
        else
          livre = livre.first
          if description.present?
            livre.description = description
          end
          if nbPages.present?
            livre.nb_pages = nbPages
          end
          livre.save
          @channel.push({class: "info", content: "Le livre #{titre_str} existe d&eacute;j&agrave;. Mis &agrave; jour."}.to_json)
        end

      else
        @channel.push({class: "error", content: "ISBN #{isbn} non trouv&eacute; sur GoogleBookAPI."}.to_json)
      end
      

    end

    ws.onclose do 
      @channel.push({class: "info", content: "#{sid} se casse !"}.to_json)
      @channel.unsubscribe(sid)
    end
  end
  end
end