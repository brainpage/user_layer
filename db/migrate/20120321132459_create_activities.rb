class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :creator_id, :time_span, :money_account
      t.string :token
      t.timestamps
    end
    
    add_index :activities, :token, :unique => true
  end
end
