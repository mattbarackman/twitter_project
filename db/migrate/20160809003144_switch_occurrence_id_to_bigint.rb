class SwitchOccurrenceIdToBigint < ActiveRecord::Migration[5.0]
  def up
    change_column :occurrences, :id, :integer, :limit => 8
  end

  def down
    change_column :occurrences, :id, :integer, :limit => 4
  end
end
