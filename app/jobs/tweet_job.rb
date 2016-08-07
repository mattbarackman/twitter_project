class TweetJob < ApplicationJob
  queue_as :default

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    topic = Topic.find(tweet.topic_id)

    topic.increment_mentions
    topic.increment_words(tweet.words)
    topic.increment_hashtags(tweet.hashtags)
    topic.increment_users(tweet.users)

    tweet.destroy
  end
end