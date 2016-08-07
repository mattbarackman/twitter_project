class TweetJob < ApplicationJob
  queue_as :default

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    topic = Topic.find(tweet.topic_id)
    topic.process_tweet(tweet)
    tweet.destroy
  end
end