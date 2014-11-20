File.open('montestimages.html', 'w+') do |file|
  Google::Search::Image.new(:query => 'Henning Mankell').each do |image|
    file.write %(<img src="#{image.uri}">)
  end
end