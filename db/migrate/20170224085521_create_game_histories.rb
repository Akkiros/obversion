class CreateGameHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :game_histories do |t|
      t.json :game_data
      t.timestamp :start_time
      t.references :game, index: true

      t.timestamps
    end
  end
end
