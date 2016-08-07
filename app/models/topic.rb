class Topic < ActiveRecord::Base

  include Redis::Objects

  counter :mentions_count

  counter :word_count
  sorted_set :ranked_words

  counter :hashtag_count
  sorted_set :ranked_hashtags

  counter :user_count
  sorted_set :ranked_users

  # MENTIONS

  def increment_mentions
    mentions_count.increment
  end

  def mentions
    mentions_count.value
  end

  # WORDS

  def increment_words(words)
    words.each do |word|
      word_count.increment
      ranked_words[word] += 1
    end
  end

  def top_words(n = 10)
    top = ranked_words.revrange(0,n)
    top.map { |word| Word.new(word, self).as_json}
  end

  def word_score(word)
    ranked_words[word] / word_count.value.to_f
  end

  # HASHTAGS

  def increment_hashtags(hashtags)
    hashtags.each do |hashtag|
      hashtag_count.increment
      ranked_hashtags[hashtag] += 1
    end
  end

  def hashtag_score(hashtag)
    (ranked_hashtags[hashtag] / hashtag_count.value.to_f)
  end

  def top_hashtags(n = 10)
    top = ranked_hashtags.revrange(0,n)
    top.map { |hashtag| Hashtag.new(hashtag, self).as_json}
  end

  # USERS

  def increment_users(users)
    users.each do |user|
      user_count.increment
      ranked_users[user] += 1
    end
  end

  def user_score(user)
    (ranked_users[user] / user_count.value.to_f)
  end

  def top_users(n = 10)
    top = ranked_users.revrange(0,n)
    top.map { |user| User.new(user, self).as_json}
  end

  def as_json
    {
      id: id,
      name: name,
      mentions: mentions,
      topWords: top_words,
      topUsers: top_users,
      topHashtags: top_hashtags,
    }
  end

end