class CreateGamePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :game_players do |t|
      t.references :player, index: true
      t.references :game, index: true

      t.timestamps
    end
  end
end
