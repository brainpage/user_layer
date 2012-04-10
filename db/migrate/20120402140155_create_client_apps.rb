class CreateClientApps < ActiveRecord::Migration
  def change
    create_table :client_apps do |t|
      t.decimal :dur, :precision => 3, :scale => 2
      t.integer :client_event_id, :keys, :msclks, :dst
      t.string :app
      t.timestamps
    end
  end
end
