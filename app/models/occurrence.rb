class Occurrence < ActiveRecord::Base

  def self.since(timeAgo = 1.hour.ago)
    where("occurrences.tweeted_at >= '#{timeAgo}'")
  end

  def self.delete_old
    where("tweeted_at < '#{1.hour.ago}'").destroy_all
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
      id: Digest::MD5.hexdigest(value),
      count: count,
      value: formatted_value,
      link: link
    }
  end

end