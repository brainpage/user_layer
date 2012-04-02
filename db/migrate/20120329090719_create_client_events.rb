class CreateClientEvents < ActiveRecord::Migration
  def change
    create_table :client_events do |t|
      t.integer :dur, :mnum, :dst, :keys, :msclks, :scrll, :point
      t.string :app
      t.timestamps
    end

  end
end
