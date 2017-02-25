class GamePlayer < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates :status, presence: true
  validates :player_id, presence: true
  validates :game_id, presence: true
end
