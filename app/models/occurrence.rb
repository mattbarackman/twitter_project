class Occurrence < ApplicationRecord

  TTL = 1.hour

  belongs_to :topic

  validates_presence_of :topic, :value, :tweeted_at

  def self.recent
    where("occurrences.tweeted_at >= '#{TTL.ago}'")
  end

  def self.old
    where("occurrences.tweeted_at < '#{TTL.ago}'")
  end

  def self.top(n = 10)
    select('count(*) as count, value')
      .group(:value)
      .order('count DESC')
      .limit(n)
      .map(&:occurrence_with_count_as_json)
  end

  def occurrence_with_count_as_json
    {
      key: Digest::MD5.hexdigest(value),
      count: count,
      value: formatted_value,
      link: link
    }
  end

  def self.top_recent
    recent.top
  end

end