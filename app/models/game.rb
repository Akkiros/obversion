class Game < ApplicationRecord
  has_many :game_players
  has_many :players, through: :game_players
  has_many :game_histories

  validates :status, presence: true, length: { maximum: 16 }
end
