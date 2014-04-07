web: bundle exec rails s
redis: redis-server
resque: bundle exec rake environment resque:work QUEUE=*
clock: bundle exec clockwork lib/clock.rb