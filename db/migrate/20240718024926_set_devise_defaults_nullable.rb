class SetDeviseDefaultsNullable < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, name: "index_users_on_reset_password_token"
    remove_index :users, name: "index_users_on_confirmation_token"
    add_index :users, "reset_password_token", name: "index_users_on_reset_password_token", where: 'reset_password_token IS NOT NULL'
    add_index :users, "confirmation_token", name: "index_users_on_confirmation_token", where: 'confirmation_token IS NOT NULL'
  end
end
