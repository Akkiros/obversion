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

    if game.nil?
      puts 'game is not found'
      return redirect_to action: 'index'
    end

    if player.nil?
      puts 'player is not found'
      return redirect_to accounts_path
    end

    if game.full?
      puts 'full'
      return redirect_to action: 'index'
    end

    if game.started?
      puts 'started'
      return redirect_to action: 'index'
    end

    # TODO: make status to constant
    game.game_players.create(player: player, status: 'joined')

    # TODO: broadcast data to consumers
    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: 'join',
      player_id: player.id,
      current_player_count: game.active_player_count
    )
    #redirect_to action: 'show', game_id: game.id
  end

  def leave
    game = Game.find_by(id: params[:game_id])
    player = Player.find_by(id: session[:player_id])

    # TODO: check player is now joined status in this game?

    if game.started?
      puts 'game is already started!'
      return
    end

    player.leave_game(game.id)

    redirect_to games_path
  end

  def show
    @game = Game.find_by(id: params[:game_id])

    # TODO: refactor this
    game_players = @game.game_players.where(status: 'joined')
    @game_player_first_id = game_players.first ? game_players.first.player_id : 'not yet'
    @game_player_last_id = game_players.last ? game_players.last.player_id : 'not yet'
  end

  def start
    game = Game.find_by(id: params[:game_id])
    unless game.full?
      puts 'not full'
      return redirect_back(fallback_location: games_show_path(game_id: game.id))
    end

    game.start
    render json: game.game_histories.last.game_data.to_json
    # TODO: broadcast data to consumers
  end

  def ping
    ActionCable.server.broadcast(
      "games/#{params[:game_id]}",
      message: 'test'
    )
    head :ok
  end
end
