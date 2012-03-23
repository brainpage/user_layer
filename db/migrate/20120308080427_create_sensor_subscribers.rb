class CreateSensorSubscribers < ActiveRecord::Migration
  def change
    create_table :sensor_subscribers do |t|
      t.integer :sensor_id
      t.integer :app_id

      t.timestamps
    end
  end
end
