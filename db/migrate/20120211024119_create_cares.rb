class CreateCares < ActiveRecord::Migration
  def change
    create_table :cares do |t|
      t.integer :owner_id
      t.string :name, :phone_number, :email
      t.timestamps
    end
    
    add_index :cares, :owner_id
  end
end
