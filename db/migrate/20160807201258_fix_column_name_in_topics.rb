class FixColumnNameInTopics < ActiveRecord::Migration[5.0]
  def change
    rename_column :topics, :name, :value
  end
end
