class CreateProcessedData < ActiveRecord::Migration
  def change
    create_table :processed_data do |t|
      t.datetime :date
      t.string :category
      t.float :value
      t.integer :samples
      t.string :type
      t.boolean :is_all_time
      t.timestamps
    end
    add_index :processed_data, :category
  end
end
