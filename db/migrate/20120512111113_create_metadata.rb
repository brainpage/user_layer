class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|

      t.timestamps
    end
  end
end
