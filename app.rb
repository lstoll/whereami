require 'sinatra'
require 'rack'
require 'json'
require 'lib/location'

configure :development do
  Sinatra::Application.reset!
  use Rack::Reloader
end

configure do
  require 'env'
end

get "/" do
  loc = get_location
  if loc[:city] == 'N/A'
    "<html><body><h1>Location Currently Unavailable...</body></html>"
  else
    query = CGI::escape(stringify_location(get_location))
    redirect "http://maps.google.com/maps?q=#{query}&z=6"
  end
end

get "/loc.json" do
  "#{params[:callback]}(#{get_location.to_json});"
end
