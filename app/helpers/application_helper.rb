module ApplicationHelper

	def download_image_from_url(url)
    uri  = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = url.include?('https')

    response = http.request(
      Net::HTTP::Get.new(uri.request_uri, {
        'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0'
      })
    )
    path = "tmp/images"
    random_token = Digest::SHA2.hexdigest("#{Time.now.utc}").first(10)
    name = "#{random_token}.png"
    File.open(File.join(path, name), 'wb') { |f| f.write(response.body) }
    "#{path}/#{name}"
  end
    
end
