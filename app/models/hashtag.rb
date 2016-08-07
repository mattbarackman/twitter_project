class Hashtag

  TTL = 300

  attr_reader :value, :topic

  include Redis::Objects

  counter :next_occurence_id, global: true

  def initialize(hashtag, topic)
    @value = hashtag
    @topic = topic
  end

  def redis_prefix
    [topic.redis_prefix, "hashtags", value].join(":")
  end

  def occurences
    key = [redis_prefix, "*"].join(":")
    redis.keys(key).count
  end

  def save_occurence
    key = [redis_prefix, next_occurence_id.increment].join(":")
    redis.set(key,  true)
    redis.expire(key,  TTL)
  end

  def link
    URI.encode("https://twitter.com/hashtag/#{without_symbol}")
  end

  def without_symbol
    value[1..-1]
  end

  def id
    @id ||= Digest::MD5.hexdigest(value + topic.name)
  end

  def score
    occurences / topic.hashtag_occurences.to_f
  end

  def as_json
    {
      id: id,
      value: value,
      score: occurences,
      link: link
    }
  end

end