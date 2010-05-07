require 'twitter'
require 'geokit'

include Geokit::Geocoders

def get_location
  begin
    CACHE.get 'lstoll-loc-data'
  rescue Memcached::NotFound
    # If it's more than 8 hrs old, it's expired
    expires_in = 8 * 60 * 60
    puts "Re-loading data from twitter"
    coords = nil
    updated = nil
    page = 0
    until coords
      if tweet = TWITTER_CLIENT.user_timeline(:page => page).detect do
          |t| t.coordinates
        end
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

def stringify_location(loc, type=:long)
  if type == :short
    "#{loc[:city]}, #{loc[:country]}"
  else
    "#{loc[:city]}, #{loc[:state]}, #{loc[:country]}"
  end
end
