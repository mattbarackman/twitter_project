class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics, :id => :uuid do |t|
      t.string :value, :nullable => false
      t.timestamps
    end
  end
end
