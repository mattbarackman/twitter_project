class TweetParser

  attr_accessor :words, :hashtags, :users

  def initialize(input_string)
    @stopword_filter = Stopwords::Snowball::Filter.new "en", CUSTOM_STOP_WORDS
    @words = []
    @hashtags = []
    @users = []
    input_string = remove_urls(input_string)
    input_string = unescapeHTML(input_string)
    populate_sets(input_string)
  end

  def populate_sets(input_string)
    new_words = input_string.split(/[^\w@#\-']/)

    new_words.flat_map do |word|
      clean_up_punctuation(word)
    end.compact.each do |word|
      if hash_tag?(word)
        @hashtags << (word)
      elsif user?(word)
        @users << (word)
      else
        @words << word.downcase unless filter_word?(word)
      end
    end
  end

  def remove_urls(input_string)
    input_string.gsub(URL_REGEX, "")
  end

  def unescapeHTML(input_string)
    CGI.unescapeHTML(input_string)
  end

  def filter_word?(word)
    @stopword_filter.stopword?(word.downcase) || word.length <= 1
  end

  def hash_tag?(word)
    word[0] == "#"
  end

  def user?(word)
    word[0] == "@"
  end

  def clean_up_punctuation(word)

    new_words = []
    current_word = ""


    0.upto(word.length - 1) do |i|

      char = word[i]

      if ["#", "@"].include? char
        new_words << current_word unless current_word.empty?
        current_word = char
      elsif ["-", "'"].include?(char) && (!is_letter?(word[i-1]) || !is_letter?(word[i+1]))
        new_words << current_word unless current_word.empty?
        current_word = ""
      elsif ["-", "'"].include?(char) && (current_word.include?("#") || current_word.include?("@"))
        new_words << current_word unless current_word.empty?
        current_word = ""
      else
        current_word += char
      end
    end

    if !current_word.empty? && !["#", "@"].include?(current_word)
      new_words << current_word
    end

    new_words

  end

  def is_letter?(char)
    (("a".."z").to_a + ("A".."Z").to_a).include?(char)
  end

end