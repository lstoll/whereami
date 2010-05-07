require 'memcached'
require 'twitter'

CACHE = Memcached.new
httpauth = Twitter::HTTPAuth.new(ENV['TWITTER_USERNAME'], ENV['TWITTER_PASSWORD'])
TWITTER_CLIENT = Twitter::Base.new(httpauth)
