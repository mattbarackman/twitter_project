class DropUnnecessaryTables < ActiveRecord::Migration[5.0]
  def change
 
  drop_table :topics_hashtags
  drop_table :hashtags
  drop_table :topics_user_mentions
  drop_table :user_mentions
  drop_table :topics_urls
  drop_table :urls

  end
end
