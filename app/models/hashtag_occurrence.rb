class HashtagOccurrence < Occurrence

  def link
    URI.encode("https://twitter.com/hashtag/#{value}")
  end

  def formatted_value
    "#" + value
  end

end