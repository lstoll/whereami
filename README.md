# Where is lstoll

A simple sinatra app, guesses location from twitter feed, reverse geocodes it,
and makes it available via JSON-P

## Installation

Runs on heroku. Requires the memcache addon
    
    heroku addons:add memcache:5mb

Also requires the TWITTER\_USERNAME and TWITTER\_PASSWORD environment variables set

    heroku config:add TWITTER_USERNAME=xxxx TWITTER_PASSWORD=xxxx
    
And if you want it to update your twitter _profile_ location, enable cron

    heroku addons:add cron:daily
