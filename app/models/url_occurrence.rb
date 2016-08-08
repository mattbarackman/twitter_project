class UrlOccurrence < Occurrence

  def link
    value
  end


  def formatted_value
    if value.length > 40
      value[0..40]+"..."
    else
      value
    end
  end

end