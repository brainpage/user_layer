class CreateDataQueries < ActiveRecord::Migration
  def change
    create_table :data_queries do |t|
      t.integer :user_id
      t.string :name, :identifier
      t.text :query_clause
      t.timestamps
    end
    
    add_index :data_queries, :user_id
  end
end
