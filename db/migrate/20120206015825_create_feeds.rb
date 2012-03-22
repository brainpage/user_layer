class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.references :originator, :polymorphic => true 
      t.string :event_id, :xtype
      t.integer :user_id, :referer_id
      
      t.timestamps
    end
    
    add_index :feeds, :user_id
  end
end
