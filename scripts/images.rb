File.open('montestimages.html', 'w+') do |file|
  Google::Search::Image.new(:query => 'Henning Mankell').each do |image|
    file.write %(<img src="#{image.uri}">)
    puts image.uri
  end
end