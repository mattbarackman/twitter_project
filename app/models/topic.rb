class Topic < ActiveRecord::Base

  has_many :occurrences, :as => :occurrable, :dependent => :destroy

  has_many :topics_user_mentions, :dependent => :destroy
  has_many :user_mentions, :through => :topics_user_mentions

  has_many :topics_urls, :dependent => :destroy
  has_many :urls, :through => :topics_urls

  has_many :topics_hashtags, :dependent => :destroy
  has_many :hashtags, :through => :topics_hashtags

  def self.streaming(command)
    raise ArguementError unless ['restart', 'start', 'stop', 'status'].include? command
    if any?
      system("ruby #{TWEET_STREAM_DAEMON_PATH} #{command}")
    else
      p "No topics were found."
    end
  end

  def recent_occurrence_count
    occurrences.since(1.hour.ago).count
  end

  def top_recent_hashtags(n = 10)
    topics_hashtags.
      with_recent_occurrences.
      group(:hashtag).
      count.
      sort_by{|r| [r[1], r[0].value]}.
      last(n).
      reverse.
      map{|result| result[0].as_json.merge({"count" => result[1]})}
  end

  def top_recent_urls(n = 10)
    topics_urls.
      with_recent_occurrences.
      group(:url).
      count.
      sort_by{|r| [r[1], r[0].value]}.
      last(n).
      reverse.
      map{|result| result[0].as_json.merge({"count" => result[1]})}
  end

  def top_recent_user_mentions(n = 10)
    topics_user_mentions.
      with_recent_occurrences.
      group(:user_mention).
      count.
      sort_by{|r| [r[1], r[0].value]}.
      last(n).
      reverse.
      map{|result| result[0].as_json.merge({"count" => result[1]})}
  end

  def as_json(root = false)
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

  def streaming_daemon_name
    "tweet_streamer_#{id}"
  end

end