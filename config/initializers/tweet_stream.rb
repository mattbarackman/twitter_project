TweetStream.configure do |conf|
  conf.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  conf.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  conf.oauth_token         = ENV['TWITTER_ACCESS_TOKEN']
  conf.oauth_token_secret  = ENV['TWITTER_ACCESS_SECRET']
  conf.auth_method         = :oauth
end

TWEET_STREAM_DAEMON_PATH = Rails.root.join("lib/tweet_stream.rb").to_s
