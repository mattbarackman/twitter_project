class UserMention < ActiveRecord::Base

  has_many :topics_user_mentions
  has_many :topics, :through => :topics_user_mentions

  def link
    URI.encode("https://twitter.com/#{value}")
  end

  def to_s
    "@" + value
  end

  def as_json
    {
      id: id,
      value: to_s,
      link: link
    }
  end

end