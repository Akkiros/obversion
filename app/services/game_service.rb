class GameService
  # TODO: nil check 하나로 모으기
  def self.can_join?(game_id, player_id)
    game = Game.find_by(id: game_id)
    player = Player.find_by(id: player_id)
    url_helpers = Rails.application.routes.url_helpers

    if game.nil?
      puts 'game is not found' 
      return [false, 'game is not found',  url_helpers.games_path]
    end

    if player.nil?
      puts 'player is not found'
      return [false, 'player is not found', url_helpers.accounts_path]
    end

    if player.already_joined?(game.id)
      puts 'player already joined'
      return [false, 'player already joined', url_helpers.games_path]
    end

    if game.full?
      puts 'full'
      return [false, 'this game is full', url_helpers.games_path]
    end

    if game.started?
      puts 'started'
      return [false, 'this game already started', url_helpers.games_path]
    end

    return true
  end

  def self.join(game_id, player_id)
    game = Game.find_by(id: game_id)
    player = Player.find_by(id: player_id)

    game.game_players.create(player: player, status: GameConstant::STATUS_JOINED)

    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: GameConstant::STATUS_JOINED,
      player_id: player_id,
      current_player_count: game.active_player_count
    )
  end

  def self.can_leave?(game_id, player_id)
    game = Game.find_by(id: game_id)
    player = Player.find_by(id: player_id)

    unless player.already_joined?(game_id)
      return [false, 'not joined this game']
    end

    if game.started?
      return [false, 'game is already started']
    end

    return true
  end

  def self.leave(game_id, player_id)
    game = Game.find_by(id: game_id)
    player = Player.find_by(id: player_id)

    player.leave_game(game.id)

    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: GameConstant::STATUS_LEAVED,
      player_id: player.id,
      active_player_ids: game.active_player_ids,
      current_player_count: game.active_player_count
    )
  end

  def self.can_start?(game_id, player_id)
    game = Game.find_by(id: game_id)
    player = Player.find_by(id: player_id)

    unless player.already_joined?(game_id)
      return [false, 'this player not joined this game']
    end

    unless game.full?
      return [false, 'not full']
    end

    if game.started?
      return [false, 'this game is already started']
    end

    return true
  end

  def self.start(game_id)
    game = Game.find_by(id: game_id)
    game.start

    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: GameConstant::STATUS_STARTED,
      remain_time: 60
    )

    QC::enqueue_in(60, "Game.finish", "#{game.id}")
  end

  def self.can_click?(game_id, player_id)
    game = Game.find_by(id: game_id)
    player = Player.find_by(id: player_id)

    if game.nil?
      puts 'game is nil'
      return
    end

    unless player.already_joined?(game_id)
      return [false, 'this player not joined this game']
    end

    unless game.started?
      return [false, 'game is not started']
    end

    return true
  end

  def self.click(game_id, player_id, x, y)
    game = Game.find_by(id: game_id)

    color_key = game.active_player_ids.index(player_id)
    color = GameConstant::COLOR_KEY[color_key]

    last_game_history = game.game_histories.last
    new_matrix = JSON.parse(last_game_history.game_data)['matrix']
    new_matrix[x.to_i][y.to_i] = color_key

    score = {
      '0': 0,
      '1': 0
    }
    new_matrix.count.times do |i|
      new_matrix.count.times do |j|
        score[0.to_s.to_sym] += 1 if new_matrix[i][j] == 0
        score[1.to_s.to_sym] += 1 if new_matrix[i][j] == 1
      end
    end

    game.game_histories.create(
      game_data: {
        status: GameConstant::STATUS_PLAYING,
        matrix: new_matrix,
        score: score
      }.to_json
    )

    ActionCable.server.broadcast(
      "games/#{game.id}",
      status: GameConstant::STATUS_PLAYING,
      color: color,
      game_data: {
        x: x,
        y: y
      },
      score: score
    )
  end
end
