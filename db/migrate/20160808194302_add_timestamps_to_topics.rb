class AddTimestampsToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :created_at, :datetime
    add_column :topics, :updated_at, :datetime

    Topic.all.each do |topic|
      topic.created_at = DateTime.current
      topic.updated_at = DateTime.current
      topic.save
    end

    change_column :topics, :created_at, :datetime, :null => false
    change_column :topics, :updated_at, :datetime, :null => false

  end
end
