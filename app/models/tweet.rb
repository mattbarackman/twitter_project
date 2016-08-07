class Tweet

  include Redis::Persistence

  property :text
  property :topic_id

  def parsed
    @parsed ||= TweetParser.new(text)
  end

  def words
    parsed.words
  end

  def hashtags
    parsed.hashtags
  end

  def users
    parsed.users
  end

end