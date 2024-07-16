class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games, id: :uuid do |t|
      # enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
      t.text :game_state

      t.timestamps
    end
  end
end
