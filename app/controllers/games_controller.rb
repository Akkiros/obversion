require 'queue_classic'

class GamesController < ApplicationController
  before_action :require_login

  def index
    @games = Game.where(status: GameConstant::STATUS_NEW)
  end

  def new
  end

  def create
    game = Game.new(title: params[:games][:title], status: GameConstant::STATUS_NEW)
    unless game.valid?
      flash[:notice] = game.errors.full_messages
      return redirect_to games_new_path
    end

    if game.save
      GameService::join(game.id, session[:player_id])
      return redirect_to action: 'show', game_id: game.id
    end
  end

  def join
    result, message, redirection_path = GameService::can_join?(params[:game_id], session[:player_id])
    unless result
      flash[:notice] = message
      return redirect_to redirection_path
    end

    GameService::join(params[:game_id], session[:player_id])
  end

  def leave
    result, message = GameService::can_leave?(params[:game_id], session[:player_id])
    unless result
      flash[:notice] = message
      return redirect_to games_path
    end

    GameService::leave(params[:game_id], session[:player_id])

    redirect_to games_path
  end

  def show
    @game = Game.find_by(id: params[:game_id])
    @game_player_ids = @game.active_player_ids

    # game is started or finished load data
    if @game.started? || @game.finished?
      @last_game_history = JSON.parse(@game.game_histories.last.game_data)
      @last_matrix = @last_game_history['matrix']
      @last_score = @last_game_history['score']
    else
      @last_score = GameConstant::DEFAULT_SCORE
    end
  end

  def start
    result, message = GameService::can_start?(params[:game_id], session[:player_id])
    unless result
      flash[:notice] = message
      return redirect_back(fallback_location: games_path)
    end

    GameService::start(params[:game_id])
  end

  def click
    result, message = GameService::can_click?(params[:game_id], session[:player_id], params[:x], params[:y])
    unless result
      return render json: {success: false, message: message}, status: 500
    end

    GameService::click(params[:game_id], session[:player_id], params[:x], params[:y])
  end
end
