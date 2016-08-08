class CreateTopicsUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :topics_urls do |t|
      t.references :topic
      t.references :url
      t.timestamps
    end
  end
end
