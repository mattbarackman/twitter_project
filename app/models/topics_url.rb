class TopicsUrl < ActiveRecord::Base

  belongs_to :topic
  belongs_to :url

  has_many :occurrences, :as => :occurrable, :dependent => :destroy

  def self.with_recent_occurrences(timeAgo = 1.hour.ago)
    joins(:occurrences).
    where("occurrences.tweeted_at >= '#{timeAgo}'")
  end

end