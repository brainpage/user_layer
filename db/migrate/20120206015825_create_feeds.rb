class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.references :originator, :polymorphic => true 
      t.string :event_id, :text_key, :hook_method
      t.integer :user_id
      
      t.timestamps
    end
    
    add_index :feeds, [:user_id, :created_at]
  end
end
