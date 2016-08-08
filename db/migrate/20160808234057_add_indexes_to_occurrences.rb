class AddIndexesToOccurrences < ActiveRecord::Migration[5.0]
  def change
    add_index :occurrences, [:topic_id, :type]
  end
end
