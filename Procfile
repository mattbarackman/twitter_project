web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
stream: bundle exec rake topics:stream
worker: bundle exec sidekiq -C config/sidekiq.yml
