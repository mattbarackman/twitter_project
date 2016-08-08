web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
streaming: bundle exec rake topics:stream
sidekiq: bundle exec sidekiq -C config/sidekiq.yml
