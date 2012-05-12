class AddFieldsToSensor < ActiveRecord::Migration
  def change
    add_column :sensors, :stateless_timeout, :integer, :default => 60
    add_column :sensors, :timestamp_sig_digits, :integer, :default => 0
  end
end
