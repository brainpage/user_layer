class CreateActivityUsers < ActiveRecord::Migration
  def change
    create_table :activity_users do |t|
      t.integer :activity_id, :user_id
      t.timestamps
    end
    
    add_index :activity_users, [:activity_id, :user_id]
  end
end
