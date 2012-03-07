class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
     t.references :creator, :polymorphic => true 
      t.string :event_id
      t.text :text
      t.integer :user_id

      t.timestamps
    end
  end
end
