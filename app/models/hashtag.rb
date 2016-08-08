class Hashtag < ActiveRecord::Base

  has_many :topics_hashtags
  has_many :topics, :through => :topics_hashtags

  def link
    URI.encode("https://twitter.com/hashtag/#{value}")
  end

  def to_s
    "#" + value
  end

  def as_json
    {
      id: id,
      value: to_s,
      link: link
    }
  end

end