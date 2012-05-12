class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.has_attached_file :content
      t.timestamps
    end
  end
end
