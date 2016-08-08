class UsernameOccurrence < Occurrence

  def link
    URI.encode("https://twitter.com/#{value}")
  end

  def formatted_value
    "@" + value
  end

end