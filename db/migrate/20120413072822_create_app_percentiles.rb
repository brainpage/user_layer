class CreateAppPercentiles < ActiveRecord::Migration
  def change
    create_table :app_percentiles do |t|
      t.string :app
      t.integer :value, :percentile
      t.timestamps
    end
    
    add_index :app_percentiles, [:app, :value]
  end
end
