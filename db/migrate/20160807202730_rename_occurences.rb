class RenameOccurences < ActiveRecord::Migration[5.0]
  def change
    rename_table :occurences, :occurrences
  end
end
