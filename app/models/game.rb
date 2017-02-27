class Game < ApplicationRecord
  after_create :init_game_history

  has_many :game_players
  has_many :players, through: :game_players
  has_many :game_histories

  validates :status, presence: true, length: { maximum: 16 }

  def full?
    self.game_players.where(status: GameConstant::STATUS_JOINED).count == 2
  end

  def started?
    self.status == GameConstant::STATUS_STARTED
  end

  def playing?
    self.status == GameConstant::STATUS_PLAYING
  end

  def finished?
    self.status == GameConstant::STATUS_FINISHED
  end

  def start
    self.update(status: GameConstant::STATUS_STARTED)
  end

  def active_player_count
    self.game_players.where(status: GameConstant::STATUS_JOINED).count
  end

  def active_player_ids
    active_players = self.game_players.where(status: GameConstant::STATUS_JOINED)
    active_players.map { |data|
      data.player_id
    }
  end

  def self.finish(game_id)
    game = Game.find_by(id: game_id)
    game.update(status: GameConstant::STATUS_FINISHED)
    ActionCable.server.broadcast(
      "games/#{game_id}",
      status: GameConstant::STATUS_FINISHED,
    )
  end

  private

  def init_game_history
    self.game_histories.create(
      game_data: {
        status: GameConstant::STATUS_NEW,
        matrix: Array.new(5){Array.new(5)}
      }.to_json
    )
  end
end
