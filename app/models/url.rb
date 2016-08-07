class Url

  attr_reader :value, :topic

  def initialize(value, topic)
    @value = value
    @topic = topic
  end

  def link
    @value
  end

  def to_s
    if value.length > 40
      value[0..40]+"..."
    else
      value
    end
  end

  def id
    @id ||= Digest::MD5.hexdigest(@value + @topic.name)
  end

  def score
    topic.url_score(value)
  end

  def as_json
    {
      id: id,
      value: to_s,
      score: score,
      link: link
    }
  end

end