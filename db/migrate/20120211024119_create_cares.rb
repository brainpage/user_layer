class CreateCares < ActiveRecord::Migration
  def change
    create_table :cares do |t|
      t.integer :owner_id
      t.text :name

      t.timestamps
    end
  end
end
