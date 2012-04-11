class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :sensor_id
      t.text :name
      t.integer :num

      t.timestamps
    end
  end
end
