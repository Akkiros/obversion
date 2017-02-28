var Game = {
  init: function() {
    var game_size = 5;
    var game_data = '';

    for (var i = 0; i < game_size; i++) {
      game_data += "<div class='tiles' style='display: flex;'>";
      for (var j = 0; j < game_size; j++) {
        game_data += "<div class='tile' style='width: 20px; height: 20px; background: black; display: inline-block;' data-x=" + i + " data-y=" + j + "></div>";
      }
      game_data += "</div>";
    }

    $('.game_board').append(game_data);
  },
  join: function(response) {
    if (response.current_player_count == 1) {
      this.setPlayerId(0, response.player_id);
      this.setPlayerId(1, 'not yet');
    } else {
      $('.join_game').prop('disabled', true);
      this.setPlayerId(1, response.player_id);
    }
  },
  leave: function(response) {
    if (response.current_player_count == 1) {
      this.setPlayerId(0, response.active_player_ids[0]);
      this.setPlayerId(1, 'not yet');
      $('.join_game').prop('disabled', false);
    }
  },
  start: function(response) {
    this.changeStatus(response.status);

    $('.join_game').prop('disabled', true);
    $('.start_game').prop('disabled', true);
    $('.leave_game').prop('disabled', true);

    remain_time = response.remain_time;
    $('#remain_time > #count').text(remain_time);
  },
  play: function(response) {
    $('.game_board > .tiles:eq(' + response.game_data.x + ') > .tile:eq(' + response.game_data.y + ')')
        .css('background', response.color);

    this.setPlayerScore(0, response.score[0]);
    this.setPlayerScore(1, response.score[1]);
  },
  tick: function(response) {
    $('#remain_time > #count').text(response.remain_time);
    $('.progress > .progress-bar').css('width', Number(response.remain_time) / 60 * 100 + '%');
  },
  finish: function(response) {
    this.changeStatus(response.status);

    this.setPlayerScore(0, response.score[0]);
    this.setPlayerScore(1, response.score[1]);

    $('.winner').text('winner : ' + response.winner);
  },
  changeStatus: function(game_status) {
    $('#status > span').text(game_status);
  },
  setPlayerId: function(order, player_id) {
    if (order == 0) {
      $('#first_player > .player_id').text(player_id);
    } else {
      $('#last_player > .player_id').text(player_id);
    }
  },
  setPlayerScore: function(order, score) {
    if (order == 0) {
      $('#first_player > .score').text(score);
    } else {
      $('#last_player > .score').text(score);
    }
  }
}

if ($('#status > span').text() == 'new') {
  Game.init();
}

$('.game_board > .tiles > .tile').click(function() {
  var _this = this;
  $.ajax({
    method: 'POST',
    url: '/games/click',
    data: {
      game_id: $('#game_id').val(),
      x: $(_this).data('x'),
      y: $(_this).data('y')
    },
    error: function(response) {
      swal({
        title: 'Error!',
        text: JSON.parse(response.responseText).message,
        type: 'error',
        confirmButtonText: 'I Got It'
      });
    }
  });
});

App.messages = App.cable.subscriptions.create(
  {
    channel: 'GameChannel',
    game_id: $("#game_id").val()
  },
  {
    received: function(data) {
      if (data.status === 'joined') {
        Game.join(data);
      } else if (data.status === 'leaved') {
        Game.leave(data);
      } else if (data.status === 'started') {
        Game.start(data);
      } else if (data.status === 'playing') {
        Game.play(data);
      } else if (data.status === 'tick') {
        Game.tick(data);
      } else if (data.status === 'finished') {
        Game.finish(data);
      } else {
        console.log('i dont understant this status' + data.status);
      }
    },
  }
);
