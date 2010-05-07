require 'sinatra'
require 'rack'
require 'twitter'
require 'geokit'
include Geokit::Geocoders
require 'memcached'
require 'json'

configure :development do
  Sinatra::Application.reset!
  use Rack::Reloader
end

configure do
  CACHE = Memcached.new
end

def get_location
  begin
    CACHE.get 'lstoll-loc-data'
  rescue Memcached::NotFound
    # If it's more than 8 hrs old, it's expired
    expires_in = 8 * 60 * 60
    puts "Re-loading data from twitter"
    httpauth = Twitter::HTTPAuth.new(ENV['TWITTER_USERNAME'], ENV['TWITTER_PASSWORD'])
    client = Twitter::Base.new(httpauth)
    coords = nil
    updated = nil
    page = 0
    until coords
      if tweet = client.user_timeline(:page => page).detect { |t| t.coordinates }
        coords = tweet.coordinates.coordinates
        updated = tweet.created_at
      end
      page += 1
    end
    # need to switch coord order
    require 'pp'
    loc = GoogleGeocoder.reverse_geocode([coords[1], coords[0]])
    loc_data = { :city => [loc.city, loc.district,  'N/A'].compact[0],
      :state => [loc.state, 'N/A'].compact[0],
      :country => [loc.country, 'N/A'].compact[0],
      :updated => [updated, 'N/A'].compact[0]
    }
    CACHE.set 'lstoll-loc-data', loc_data, expires_in
    loc_data
  end
end

get "/" do
  "Nothing to see here yet..."
end

get "/loc.json" do
  "#{params[:callback]}(#{get_location.to_json});"
end
