class CreateActivityGroups < ActiveRecord::Migration
  def change
    create_table :activity_groups do |t|
      t.string :code, :description
      t.integer :creator_id
      t.timestamps
    end
    
    add_index :activity_groups, :code, :unique => true
  end
end
