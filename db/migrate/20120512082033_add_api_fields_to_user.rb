class AddApiFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :api_secret_key, :string
    add_column :users, :api_token, :string

    add_index :users, [:api_token, :api_secret_key]
  end
end
