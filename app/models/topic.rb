class Topic < ActiveRecord::Base

  has_many :tweet_occurrences, :dependent => :destroy
  has_many :hashtag_occurrences, :dependent => :destroy
  has_many :url_occurrences, :dependent => :destroy
  has_many :username_occurrences, :dependent => :destroy

  def process_tweet!(tweet_info)
    tweeted_at = tweet_info[:tweeted_at]

    tweet_occurrences.create(value: tweet_info[:twitter_id], tweeted_at: tweeted_at)

    tweet_info[:hashtags].each do |value|
      hashtag_occurrences.create(value: value, tweeted_at: tweeted_at )
    end

    tweet_info[:urls].each do |value|
      url_occurrences.create(value: value, tweeted_at: tweeted_at )
    end

    tweet_info[:usernames].each do |value|
      username_occurrences.create(value: value, tweeted_at: tweeted_at )
    end
  end

  def top_recent_hashtags(timeAgo = 1.hour.ago, n = 10)
    hashtag_occurrences
      .since(timeAgo)
      .top(n)
  end

  def top_recent_urls(timeAgo = 1.hour.ago, n = 10)
    url_occurrences
      .since(timeAgo)
      .top(n)
  end

  def top_recent_usernames(timeAgo = 1.hour.ago, n = 10)
    username_occurrences
      .since(timeAgo)
      .top(n)
  end

  def recent_tweet_count(timeAgo = 1.hour.ago)
    tweet_occurrences
      .since(timeAgo)
      .count
  end

  def as_json(root = false)
    Rails.cache.fetch("topics/#{id}/json", expires_in: 1.second) do
      {
        id: id,
        value: value,
        data: {
          mentions: recent_tweet_count,
          topUsernames: top_recent_usernames,
          topHashtags: top_recent_hashtags,
          topUrls: top_recent_urls,
        }
      }
    end
  end

end