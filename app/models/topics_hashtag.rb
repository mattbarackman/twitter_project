class TopicsHashtag < ActiveRecord::Base

  belongs_to :topic
  belongs_to :hashtag

  has_many :occurrences, :as => :occurrable, :dependent => :destroy

  def self.with_recent_occurrences(timeAgo = 1.hour.ago)
    joins(:occurrences).
    where("occurrences.tweeted_at >= '#{timeAgo}'")
  end

end