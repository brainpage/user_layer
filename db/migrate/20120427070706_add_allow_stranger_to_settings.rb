class AddAllowStrangerToSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :allow_stranger, :boolean, :default => true
  end
end
