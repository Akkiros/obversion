class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :username, limit: 32
      t.string :password, limit: 64

      t.timestamps
    end
  end
end
