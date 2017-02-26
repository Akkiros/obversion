require 'queue_classic'

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

    if player.already_joined?(game.id)
      puts 'player already joined'
      return redirect_to games_path
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

    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: 'joined',
      player_id: player.id,
      current_player_count: game.active_player_count
    )
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

    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: 'leaved',
      player_id: player.id,
      active_player_ids: game.active_player_ids,
      current_player_count: game.active_player_count
    )
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

    if game.started?
      puts 'this game is already started'
      head :ok
    end

    # TODO: 해당 게임에 속한 플레이어인지 체크

    game.start

    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: 'started',
      remain_time: 60
    )

    QC::enqueue_in(60, "Game.finish", "#{game.id}")
  end

  def click
    puts params[:x]
    puts params[:y]

    game = Game.find_by(id: params[:game_id])

    # TODO: 상태 체크
    if game.nil?
      puts 'game is nil'
      return
    end

    if game.finished?
      puts 'game is already over'
      return
    end

    color = game.active_player_ids.index(session[:player_id]) == 1 ? 'red' : 'blue'

    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: 'playing',
      color: color,
      game_data: {
        x: params[:x],
        y: params[:y]
      }
    )

    render json: {success: true}
  end
end
