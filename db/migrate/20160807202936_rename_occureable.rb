class RenameOccureable < ActiveRecord::Migration[5.0]
  def change
    rename_column :occurrences, :occureable_type, :occurrable_type
    rename_column :occurrences, :occureable_id, :occurrable_id
  end
end
