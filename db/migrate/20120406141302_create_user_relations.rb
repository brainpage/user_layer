class CreateUserRelations < ActiveRecord::Migration
  def change
    create_table :user_relations do |t|
      t.integer :inviter_id, :invitee_id
      t.timestamps
    end
    
    add_index :user_relations, :inviter_id
    add_index :user_relations, :invitee_id
  end
end
