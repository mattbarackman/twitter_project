class CreateTopicsUserMentions < ActiveRecord::Migration[5.0]
  def change
    create_table :topics_user_mentions do |t|
      t.references :topic
      t.references :user_mention
      t.timestamps
    end
  end
end
