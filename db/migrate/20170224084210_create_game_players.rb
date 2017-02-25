class CreateGamePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :game_players do |t|
      t.string :status, limit: 16, null: false, default: 'joined'
      t.references :player, index: true, null: false
      t.references :game, index: true, null: false

      t.timestamps
    end

    add_index :game_players, [:status, :player_id, :game_id], unique: true
  end
end
