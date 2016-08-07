class User

  TTL = 300

  attr_reader :value, :topic

  include Redis::Objects

  counter :next_occurence_id, global: true

  def initialize(user, topic)
    @value = user
    @topic = topic
  end

  def redis_prefix
    [topic.redis_prefix, "users", value].join(":")
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
    URI.encode("https://twitter.com/#{without_symbol}")
  end

  def without_symbol
    value[1..-1]
  end

  def id
    @id ||= Digest::MD5.hexdigest(value + topic.name)
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