class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.integer :care_id
      t.integer :app_list_id
      t.string :app_token

      t.timestamps
    end
  end
end
