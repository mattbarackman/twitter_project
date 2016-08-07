# class Word

#   TTL = 60

#   include Redis::Objects

#   counter :next_id

#   attr_reader :value, :topic

#   def initialize(value, topic)
#     @value = value
#     @topic = topic
#   end

#   def current_count
#     redis.keys("#{redis_prefix}:*").count
#   end

#   def link
#     URI.encode("https://twitter.com/search?q=#{value}")
#   end

#   def without_symbol
#     value[1..-1]
#   end

#   def to_s
#     value
#   end

#   def id
#     @id ||= Digest::MD5.hexdigest(@value + @topic.name)
#   end

#   def score
#     topic.word_score(value)
#   end

#   def as_json
#     {
#       id: id,
#       value: value,
#       score: score,
#       link: link
#     }
#   end

#   def redis_prefix
#     "#{topic.redis_prefix}:#{word}"
#   end

#   def save()
#     next_id.increment
#     REDIS.set(redis_key,  true)
#     REDIS.expire(redis_key,  TTL)
#   end

# end