# encoding: UTF-8
require 'net/http'

EventMachine.run do
  puts "Ready !"
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(host: Rails.application.config.ipadress, port: Rails.application.config.port, debug: false) do |ws|
    ws.onopen do
      sid = @channel.subscribe { |msg| ws.send(msg) }
      @channel.push("#{sid} connected")
      puts "#{sid} arrive !"


    ws.onmessage do |msg|
      isbn = msg

      puts "ISBN #{isbn}, recherche de l'ID..."
      @channel.each {|socket| socket.send msg}

      url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}")
      req = Net::HTTP::Get.new(url.to_s)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")
      res = http.request(req)
      hash = JSON.parse(res.body)
      id = hash["items"][0]["id"]

      puts "ID : #{id}, recherche des données..."
      @channel.each {|socket| socket.send msg}

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
      @channel.each {|socket| socket.send msg}

    end

    ws.onclose do 
      puts "#{sid} se casse !"
      @channel.unsubscribe(sid) }
    end
  end
end