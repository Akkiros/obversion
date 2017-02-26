require 'queue_classic'

class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
  end

  def create
    # TODO: get topic when create
    game = Game.new(status: GameConstant::STATUS_NEW)
    if game.save
      return redirect_to action: 'show', game_id: game.id
    end

    # TODO: if has error, set flash notice
  end

  def join
    result, redirection_path = GameService::can_join?(params[:game_id], session[:player_id])
    unless result
      return redirect_to redirection_path
    end

    GameService::join(params[:game_id], session[:player_id])
  end

  def leave
    result, message = GameService::can_leave?(params[:game_id], session[:player_id])
    unless result
      puts message
      return
    end

    GameService::leave(game_id, player_id)

    redirect_to games_path
  end

  def show
    @game = Game.find_by(id: params[:game_id])

    @game_player_ids = @game.active_player_ids

    # TODO: if game status is started, pass game_data from game_histories
  end

  def start
    result, message = GameService::can_start?(params[:game_id], session[:player_id])
    unless result
      puts message
      return
    end

    GameService::start(params[:game_id])
  end

  def click
    result, message = GameService::can_click?(params[:game_id], session[:player_id])
    unless result
      puts message
      return
    end

    GameService::click(params[:game_id], session[:player_id], params[:x], params[:y])
  end
end
