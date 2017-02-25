class Game < ApplicationRecord
  has_many :game_players
  has_many :players, through: :game_players
  has_many :game_histories

  validates :status, presence: true, length: { maximum: 16 }

  def full?
    self.game_players.where(status: 'joined').count == 2
  end

  def started?
    self.status == 'started'
  end

  def start
    self.update(status: 'started')
    self.game_histories.create(game_data: {status: 'started'}, start_time: Time.now)
  end
end
