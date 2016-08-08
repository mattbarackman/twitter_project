class SwitchOccurrencesToSti < ActiveRecord::Migration[5.0]
  def change
    rename_column :occurrences, :occurrable_type, :type
    remove_column :occurrences, :occurrable_id
    add_column    :occurrences, :value, :string
  end
end
