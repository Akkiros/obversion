class GamesController < ApplicationController
  def index
  end

  def new
  end

  def create
    # TODO: make status to constant
    game = Game.new(status: 'new')

    if game.save
      return redirect_to action: 'join', game_id: game.id
    end
  end

  def join
    game = Game.find_by(id: params[:game_id])

    # TODO: if game is nil

    redirect_to action: 'show', game_id: game.id
  end

  def show
    @game = Game.find_by(id: params[:game_id])
  end

  def start
  end
end
