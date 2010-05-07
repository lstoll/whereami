require 'sinatra'
require 'rack'
require 'twitter'
require 'geokit'
require 'memcached'

configure :development do
  Sinatra::Application.reset!
  use Rack::Reloader
end

configure do
  CACHE = Memcached.new
end

def get_location
  httpauth = Twitter::HTTPAuth.new(ENV['TWITTER_USERNAME'], ENV['TWITTER_PASSWORD'])
  client = Twitter::Base.new(httpauth)
  client.user_timeline.each { |tweet| puts tweet.coordinates.inspect if tweet.coordinates }
  include Geokit::Geocoders
  # need to switch coord order
  GoogleGeocoder.reverse_geocode([coord[1], coord[0]])
  
end

get "/" do
  "Nothing to see here yet..."
end

get "/loc.json" do
  "hi!"
end
