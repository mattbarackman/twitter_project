class TweetParser

  attr_accessor :words, :hashtags, :users

  URL_REGEX = /https?:\/\/[\S]+/

  CUSTOM_STOP_WORDS = %w(
    just
    like
    will
    know
    can
    one
    get
    rt
    -
    &amp;
    see
    you
    the
    of
    to
    and
    a
    in
    is
    it
    you
    that
    he
    was
    for
    on
    are
    with
    as
    I
    his
    they
    be
    at
    one
    have
    this
    from
    or
    had
    by
    hot
    word
    but
    what
    some
    we
    can
    out
    other
    were
    all
    there
    when
    up
    use
    your
    how
    said
    an
    each
    she
    which
    do
    their
    time
    if
    will
    way
    about
    many
    then
    them
    write
    would
    like
    so
    these
    her
    long
    make
    thing
    see
    him
    two
    has
    look
    more
    day
    could
    go
    come
    did
    number
    sound
    no
    most
    people
    my
    over
    know
    water
    than
    call
    first
    who
    may
    down
    side
    been
    now
    find
    any
  )


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