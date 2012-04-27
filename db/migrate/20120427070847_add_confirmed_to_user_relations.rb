class AddConfirmedToUserRelations < ActiveRecord::Migration
  def change
    add_column :user_relations, :confirmed, :boolean, :default => true
  end
end
