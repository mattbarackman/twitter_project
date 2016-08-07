class Word

  attr_reader :value, :topic

  def initialize(value, topic)
    @value = value
    @topic = topic
  end

  def link
    URI.encode("https://twitter.com/search?q=#{value}")
  end

  def without_symbol
    value[1..-1]
  end

  def to_s
    value
  end

  def id
    @id ||= Digest::MD5.hexdigest(@value + @topic.name)
  end

  def score
    topic.word_score(value)
  end

  def as_json
    {
      id: id,
      value: value,
      score: score
    }
  end

end