class AddGamePlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :player1_user_id, :bigint
    add_column :games, :player2_user_id, :bigint

    add_foreign_key :games, :users, column: :player1_user_id
    add_foreign_key :games, :users, column: :player2_user_id
  end
end
