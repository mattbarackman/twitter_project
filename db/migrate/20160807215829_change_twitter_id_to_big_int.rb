class ChangeTwitterIdToBigInt < ActiveRecord::Migration[5.0]
  def change
    change_column :tweets, :twitter_id, :bigint
  end
end
