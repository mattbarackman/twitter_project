class AddTopicIdToOccurrences < ActiveRecord::Migration[5.0]
  def change
    add_column :occurrences, :topic_id, :integer
  end
end
