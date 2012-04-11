class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.integer :user_id, :rsi_interval
      t.timestamps
    end
    
    add_index :user_settings, :user_id, :unique => true
  end
end
