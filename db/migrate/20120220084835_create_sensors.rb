class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :stype
      t.string :uid
      t.string :description
      t.boolean :public
      t.integer :owner_id
      t.timestamps
    end
  end
end
