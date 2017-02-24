class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :username, limit: 32, null: false, default: ''
      t.string :password, limit: 64, null: false, default: ''

      t.timestamps
    end
  end
end
