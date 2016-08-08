class Occurrence < ActiveRecord::Base

  belongs_to :occurrable, :polymorphic => true

  def self.since(timeAgo = 1.hour.ago)
    where("occurrences.tweeted_at >= '#{timeAgo}'")
  end

  def self.delete_old
    where("tweeted_at < '#{1.hour.ago}'").destroy_all
  end

end