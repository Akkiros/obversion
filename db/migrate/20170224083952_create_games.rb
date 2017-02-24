class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :status, limit: 16

      t.timestamps
    end
  end
end
