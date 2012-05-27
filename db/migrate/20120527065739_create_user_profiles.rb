class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :company_name, :domains
      t.timestamps
    end
    
    add_index :user_profiles, :user_id
  end
end
