class CreateGameHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :game_histories do |t|
      t.json :game_data, null: false
      t.references :game, index: true, null: false

      t.timestamps
    end
  end
end
