require 'env'
require 'lib/location'

desc "Cron task - updates twitter profile"
task :cron do
  # Update twitter profile location
  TWITTER_CLIENT.update_profile(:location => stringify_location(get_location, :short))
end
