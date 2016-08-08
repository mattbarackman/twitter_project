class UrlOccurrence < Occurrence

  def link
    value
  end


  def formatted_value
    if value.length > 25
      value[0..25]+"..."
    else
      value
    end
  end

end