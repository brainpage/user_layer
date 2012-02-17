class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :app_id
      t.string :event_id
      t.text :event
      t.integer :user_id

      t.timestamps
    end
  end
end
