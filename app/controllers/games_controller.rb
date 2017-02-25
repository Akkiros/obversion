class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
  end

  def create
    # TODO: make status to constant
    game = Game.new(status: 'new')

    if game.save
      return redirect_to action: 'show', game_id: game.id
    end
  end

  def join
    game = Game.find_by(id: params[:game_id])
    player = Player.find_by(id: session[:player_id])

    game.game_players.create(player: player)


    # TODO: if game is nil

    redirect_to action: 'show', game_id: game.id
  end

  def show
    @game = Game.find_by(id: params[:game_id])
  end

  def start
  end
end
