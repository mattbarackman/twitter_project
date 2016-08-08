class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.text :full_text
      t.integer :twitter_id
      t.datetime :tweeted_at
      t.timestamps
    end
  end
end
