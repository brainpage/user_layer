class CreateOauthAccounts < ActiveRecord::Migration
  def change
    create_table :oauth_accounts do |t|
      t.integer :user_id
      t.string :provider, :uuid, :token, :name, :email, :image
      t.datetime :token_expires_at
      t.timestamps
    end
    
    add_index :oauth_accounts, :user_id
    add_index :oauth_accounts, :provider, :uuid, :unique => true
  end
end
