class CreateOccurences < ActiveRecord::Migration[5.0]
  def change
    create_table :occurences do |t|
      t.references :occureable, :polymorphic => true, :index => true
      t.datetime :tweeted_at
      t.timestamps
    end
  end
end
