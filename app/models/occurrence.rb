class Occurrence < ActiveRecord::Base

  def self.recent
    where("occurrences.tweeted_at >= '#{DEFAULT_EXPIRATION.ago}'")
  end

  def self.delete_old
    where("tweeted_at < '#{DEFAULT_EXPIRATION}'").destroy_all
  end

  def self.top(n = 10)
    select('count(*) as count, value')
      .group(:value)
      .order('count DESC')
      .limit(n)
      .map(&:occurrence_with_count_to_json)
  end

  def occurrence_with_count_to_json
    {
      key: Digest::MD5.hexdigest(value),
      count: count,
      value: formatted_value,
      link: link
    }
  end

end