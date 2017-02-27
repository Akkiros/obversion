class GameHistory < ApplicationRecord
  belongs_to :game

  validates :game_data, presence: true
  validates :game_id, presence: true
end
