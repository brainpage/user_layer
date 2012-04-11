class AddTzToSensor < ActiveRecord::Migration
  def change
    add_column :sensors, :tz, :string
    add_column :sensors, :lat, :decimal, :precision => 15, :scale=>10
    add_column :sensors, :long, :decimal, :precision => 15, :scale=>10
  end
end
