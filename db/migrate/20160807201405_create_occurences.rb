class CreateOccurences < ActiveRecord::Migration[5.0]
  def change
    create_table :occurrences, :id => :uuid do |t|
      t.uuid :topic_id, nullable: false
      t.string :type, nullable: false
      t.string :value, nullable: false
      t.datetime :tweeted_at, nullable: false
      t.timestamps
    end

    add_index :occurrences, [:topic_id, :type]
  end
end
