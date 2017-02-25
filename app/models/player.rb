require 'digest'

class Player < ApplicationRecord
  has_many :game_players
  has_many :games, through: :game_players

  validates :username, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :password, presence: true, length: { minimum: 8, maximum: 64 }

  def self.encrypt_password(password)
    Digest::SHA256.hexdigest(password)
  end
end
