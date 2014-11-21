# File.open('montestimages.html', 'w+') do |file|
  # Google::Search::Web.new(:query => 'Calvino Italo').each do |texte|
    # file.write %(<img src="#{image.uri}">)
    # puts texte.cache_uri
  # end
# end

Google::Search::Web.new(:query => 'Calvino Italo').first(5).each do |search|
	puts "==========================================================="
  # puts search.inspect
  puts search.content
end
