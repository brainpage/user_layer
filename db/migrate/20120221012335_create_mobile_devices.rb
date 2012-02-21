class CreateMobileDevices < ActiveRecord::Migration
  def change
    create_table :mobile_devices do |t|
      t.integer :user_id
      t.string :uuid, :name, :platform, :version
      t.timestamps
    end
    
    add_index :mobile_devices, :user_id
    add_index :mobile_devices, :uuid
  end
end
