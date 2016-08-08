class DeleteTweets < ActiveRecord::Migration[5.0]
  def change
    drop_table :tweets
  end
end
