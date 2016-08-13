class Topic < ApplicationRecord

  has_many :tweet_occurrences, :dependent => :destroy
  has_many :hashtag_occurrences, :dependent => :destroy
  has_many :url_occurrences, :dependent => :destroy
  has_many :username_occurrences, :dependent => :destroy

  validates_presence_of :value

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

  def top_recent_hashtags
    hashtag_occurrences.top_recent
  end

  def top_recent_urls
    url_occurrences.top_recent
  end

  def top_recent_usernames
    username_occurrences.top_recent
  end

  def recent_tweet_count
    tweet_occurrences.recent.count
  end

  def link
    "/topics/#{id}"
  end

  def image
    Rails.application.assets.find_asset(value + ".jpg")
  end

  def image_link
    if image
      "/assets/#{image.logical_path}"
    else
      "/assets/default.jpg"
    end
  end

  def as_json(root = false)
    Rails.cache.fetch("topics/#{id}/json", expires_in: 1.second) do
      {
        id: id,
        value: value,
        link: link,
        image_link: image_link,
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