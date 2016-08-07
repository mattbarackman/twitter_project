class Topic < ActiveRecord::Base

  include Redis::Objects

  counter :mentions_count

  # MENTIONS

  def increment_mentions
    mentions_count.increment
  end

  def mentions
    mentions_count.value
  end

  def redis_prefix
    "topics:#{id}"
  end

  def component_occurence_keys(component)
    redis.keys([redis_prefix, component, "*"].join(":"))
  end

  def component_occurences(component)
    component_occurence_keys(component).size
  end

  def user_occurences
    component_occurences("users")
  end

  def user_occurence_keys
    component_occurence_keys("users")
  end

  def hashtag_occurence_keys
    component_occurence_keys("hashtags")
  end

  def url_occurence_keys
    component_occurence_keys("urls")
  end

  def users
    user_occurence_keys.map do |occurence|
      occurence.split(":")[3]
    end.uniq.map do |user|
      User.new(user, self)
    end
  end

  def hashtags
    hashtag_occurence_keys.map do |occurence|
      occurence.split(":")[3]
    end.uniq.map do |hashtag|
      Hashtag.new(hashtag, self)
    end
  end

  def urls
    url_occurence_keys.map do |occurence|
      occurence.split(":")[3]
    end.uniq.map do |url|
      Url.new(url, self)
    end
  end

  def top_users(n = 10)
    users.sort_by {|user| user.occurences}.last(n).reverse
  end

  def top_hashtags(n = 10)
    hashtags.sort_by {|hashtag| hashtag.occurences}.last(n).reverse
  end

  def top_urls(n = 10)
    urls.sort_by {|url| url.occurences}.last(n).reverse
  end

  def save_user_occurence(user_occurence)
    User.new("@" + user_occurence, self).save_occurence
  end

  def save_hashtag_occurence(hashtag_occurence)
    Hashtag.new("#" + hashtag_occurence, self).save_occurence
  end

  def save_url_occurence(url_occurence)
    Url.new(url_occurence, self).save_occurence
  end

  def process_tweet(tweet)
    increment_mentions
    tweet.hashtags.each do |hashtag|
      save_hashtag_occurence(hashtag)
    end
    tweet.users.each do |user|
      save_user_occurence(user)
    end
    tweet.urls.each do |url|
      save_url_occurence(url)
    end
  end

  def as_json(x = nil)
    {
      id: id,
      name: name,
      data: {
        mentions: mentions,
        topUsers: top_users.map(&:as_json),
        topHashtags: top_hashtags.map(&:as_json),
        topUrls: top_urls.map(&:as_json),
      }
    }
  end

  def streaming_daemon_name
    "tweet_streamer_#{id}"
  end

  def streaming(command)
    raise ArguementError unless ['restart', 'start', 'stop', 'status'].include? command
    p "#{command}ing #{streaming_daemon_name} for #{name}"
    system("ruby #{TWEET_STREAM_DAEMON_PATH} #{command} #{name}")
  end

end