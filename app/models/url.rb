class Url

  TTL = 300

  attr_reader :value, :topic

  include Redis::Objects

  counter :next_occurence_id, global: true

  def initialize(url, topic)
    @value = url
    @topic = topic
  end

  def redis_prefix
    [topic.redis_prefix, "urls", value].join(":")
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
    value
  end


  def to_s
    if value.length > 40
      value[0..40]+"..."
    else
      value
    end
  end

  def id
    @id ||= Digest::MD5.hexdigest(value + topic.name)
  end

  def score
    occurences / topic.url_occurences.to_f
  end

  def as_json
    {
      id: id,
      value: to_s,
      score: occurences,
      link: link
    }
  end

end