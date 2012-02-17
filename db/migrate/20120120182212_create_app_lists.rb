class CreateAppLists < ActiveRecord::Migration
  def change
    create_table :app_lists do |t|
      t.string :name
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
