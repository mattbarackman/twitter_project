class CreateTopicsHashtags < ActiveRecord::Migration[5.0]
  def change
    create_table :topics_hashtags do |t|
      t.references :topic
      t.references :hashtag
      t.timestamps
    end
  end
end
