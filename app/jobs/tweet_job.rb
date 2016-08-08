class TweetJob < ApplicationJob
  queue_as :default

  def perform(tweet_info)
    topic = Topic.find_or_create_by(value: tweet_info[:topic_name])
    topic.process_tweet!(tweet_info)
  end
end