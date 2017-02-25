class Game < ApplicationRecord
  has_many :game_players
  has_many :players, through: :game_players
  has_many :game_histories

  validates :status, presence: true, length: { maximum: 16 }

  def full?
    # TODO: make status to constant
    self.game_players.where(status: 'joined').count == 2
  end

  def started?
    # TODO: make status to constant
    self.status == 'started'
  end

  def start
    # TODO: make status to constant
    self.update(status: 'started')
    self.game_histories.create(game_data: {status: 'started'}, start_time: Time.now)
  end

  def active_player_count
    self.game_players.where(status: 'joined').count
  end
end
