class CreateAppPercentiles < ActiveRecord::Migration
  def change
    create_table :percentiles do |t|
      t.string :category
      t.integer :value, :percentile
      t.timestamps
    end
    
    add_index :percentiles, [:category, :value]
  end
end
