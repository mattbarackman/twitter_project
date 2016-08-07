class Tweet

  include Redis::Persistence

  property :text
  property :hashtags
  property :users
  property :urls
  property :topic_id

  # def parsed
  #   @parsed ||= TweetParser.new(text)
  # end

  # def words
  #   parsed.words
  # end

end