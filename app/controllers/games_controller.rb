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

    game.game_players.create(player: player, status: 'joined')

    redirect_to action: 'show', game_id: game.id
  end

  def show
    @game = Game.find_by(id: params[:game_id])

    # TODO: refactor this
    game_players = @game.game_players
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
  end
end
