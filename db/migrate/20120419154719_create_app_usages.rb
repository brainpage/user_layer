class CreateAppUsages < ActiveRecord::Migration
  def change
    create_table :app_usages do |t|
      t.datetime :date
      t.string :app
      t.integer :dur
      t.integer :user_id

      t.timestamps
    end
  end
end
