require 'uri'
require 'net/http'
require 'json'

url = URI("https://tmdb.lewagon.com/movie/top_rated")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
response = http.request(request)
results = JSON.parse(response.read_body)

movies = results['results']

movies.each do |movie|
  new_movie = Movie.find_or_create_by!(title: movie['title']) do |record|
    record.overview = movie['overview']
    record.rating = movie['vote_average']
    record.poster_url = "https://image.tmdb.org/t/p/original#{movie['poster_path']}"
  end

  puts "#{new_movie.title} is in the database!"
end
