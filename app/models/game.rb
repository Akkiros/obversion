class Game < ApplicationRecord
  has_many :game_players
  has_many :players, through: :game_players
  has_many :game_histories

  validates :status, presence: true, length: { maximum: 16 }

  def full?
    self.game_players.count == 2
  end

  def start
    self.update(status: 'playing')
    self.game_histories.create(game_data: {status: 'start'}, start_time: Time.now)
  end
end
