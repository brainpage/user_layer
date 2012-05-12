class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
      t.string :host_type, :key, :value
      t.integer :host_id
      t.timestamps
    end
    
    add_index :metadata, [:host_type, :host_id]
  end
end
