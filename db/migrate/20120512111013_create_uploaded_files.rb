class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.integer :sensor_id
      t.string :uuid
      t.has_attached_file :content
      t.timestamps
    end
    
    add_index :uploaded_files, :sensor_id
  end
end
