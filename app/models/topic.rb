class Topic < ActiveRecord::Base

  has_many :occurrences, :as => :occurrable, :dependent => :destroy

  has_many :topics_user_mentions, :dependent => :destroy
  has_many :user_mentions, :through => :topics_user_mentions

  has_many :topics_urls, :dependent => :destroy
  has_many :urls, :through => :topics_urls

  has_many :topics_hashtags, :dependent => :destroy
  has_many :hashtags, :through => :topics_hashtags

  def recent_occurrence_count
    occurrences.since(1.hour.ago).count
  end

  def top_recent_hashtags(n = 10)
    topics_hashtags.
      with_recent_occurrences.
      select('count(*) as count, hashtag_id').
      group('hashtag_id').
      order('count DESC').
      limit(n).map do |topics_hashtag|
        topics_hashtag.hashtag.as_json.merge(count: topics_hashtag.count)
      end
  end

  def top_recent_urls(n = 10)
    topics_urls.
      with_recent_occurrences.
      select('count(*) as count, url_id').
      group('url_id').
      order('count DESC').
      limit(n).map do |topics_url|
        topics_url.url.as_json.merge(count: topics_url.count)
      end
  end

  def top_recent_user_mentions(n = 10)
    topics_user_mentions.
      with_recent_occurrences.
      select('count(*) as count, user_mention_id').
      group('user_mention_id').
      order('count DESC').
      limit(n).map do |topics_user_mention|
        topics_user_mention.user_mention.as_json.merge(count: topics_user_mention.count)
      end
  end

  def as_json(root = false)
    Rails.cache.fetch("topics/#{id}/json", expires_in: 1.second) do
      {
        id: id,
        value: value,
        data: {
          mentions: recent_occurrence_count,
          topUserMentions: top_recent_user_mentions,
          topHashtags: top_recent_hashtags,
          topUrls: top_recent_urls,
        }
      }
    end
  end

  def streaming_daemon_name
    "tweet_streamer_#{id}"
  end

end