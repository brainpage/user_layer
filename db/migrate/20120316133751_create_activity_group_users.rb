class CreateActivityGroupUsers < ActiveRecord::Migration
  def change
    create_table :activity_group_users do |t|
      t.integer :activity_group_id, :user_id
      t.timestamps
    end
    
    add_index :activity_group_users, :activity_group_id
    add_index :activity_group_users, :user_id
    add_index :activity_group_users, [:user_id, :activity_group_id], :unique => true
  end
end
