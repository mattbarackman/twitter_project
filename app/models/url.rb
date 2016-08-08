class Url < ActiveRecord::Base

  has_many :topics_urls
  has_many :topics, :through => :topics_urls

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

  def as_json
    {
      id: id,
      value: to_s,
      link: link
    }
  end

end