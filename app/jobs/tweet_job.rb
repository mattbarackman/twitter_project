class TweetJob < ApplicationJob
  queue_as :default

  def perform(tweet_info)
    topic = Topic.find_or_create_by(value: tweet_info[:topic_name])

    topic.occurrences.create(tweet_info.slice(:tweeted_at))

    tweet_info[:hashtags].each do |value|
      hashtag = Hashtag.find_or_create_by(value: value)
      th = TopicsHashtag.find_or_create_by(hashtag_id: hashtag.id, topic_id: topic.id)
      th.occurrences.create(tweet_info.slice(:tweeted_at))
    end

    tweet_info[:user_mentions].each do |value|
      user_mention = UserMention.find_or_create_by(value: value)
      tum = TopicsUserMention.find_or_create_by(user_mention_id: user_mention.id, topic_id: topic.id)
      tum.occurrences.create(tweet_info.slice(:tweeted_at))
    end

    tweet_info[:urls].each do |value|
      url = Url.find_or_create_by(value: value)
      tu = TopicsUrl.find_or_create_by(url_id: url.id, topic_id: topic.id)
      tu.occurrences.create(tweet_info.slice(:tweeted_at))
    end

  end
end