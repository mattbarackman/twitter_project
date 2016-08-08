namespace :topics do

  task :start_streaming => :environment do |t, args|
    system("ruby #{TWEET_STREAM_DAEMON_PATH}")
  end

end