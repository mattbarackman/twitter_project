class CreateUserMentions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_mentions do |t|
      t.string :value
      t.timestamps
    end
  end
end
