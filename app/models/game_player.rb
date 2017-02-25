class GamePlayer < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates :player_id, presence: true
  validates :game_id, presence: true

  # TODO: add unique check game_id and player_id
end
