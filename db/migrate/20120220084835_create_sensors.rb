class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :stype
      t.string :uuid
      t.string :description
      t.boolean :public
      t.integer :owner_id
      t.string :access_token, :length => 20
      t.string :last_ip
      t.string :device_info
      t.timestamps
    end
  end
end
