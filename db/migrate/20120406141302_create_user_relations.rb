class CreateUserRelations < ActiveRecord::Migration
  def change
    create_table :user_relations do |t|
      t.string :type
      t.integer :user_id, :client_user_id
      t.timestamps
    end
    
    add_index :user_relations, [:type, :user_id]
    add_index :user_relations, [:type, :client_user_id]
  end
end
