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
      $('#first_player > .player_id').text(response.player_id);
      $('#last_player > .player_id').text('not yet');
    } else {
      $('.join_game').prop('disabled', true);
      $('#last_player > .player_id').text(response.player_id);
    }
  },
  leave: function(response) {
    // 0명일땐 방 폭파
    if (response.current_player_count == 1) {
      $('#first_player > .player_id').text(response.active_player_ids[0]);
      $('#last_player > .player_id').text('not yet');
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

    // TODO : 이 부분 서버로 이동
    interval = setInterval(tick, 1000);

    function tick() {
      remain_time -= 1;

      if (remain_time <= 0) {
        clearInterval(interval);
      }

      $('#remain_time > #count').text(remain_time);
    }
  },
  play: function(response) {
    $('.game_board > .tiles:eq(' + response.game_data.x + ') > .tile:eq(' + response.game_data.y + ')').css('background', response.color);
    $('#first_player > .score').text(response.score[0]);
    $('#last_player > .score').text(response.score[1]);
  },
  finish: function(response) {
    this.changeStatus(response.status);
    $('#fisrt_player > .score').text(response.score[0]);
    $('#second_player > .score').text(response.score[0]);
    $('.winner').text('winner : ' + response.winner);
  },
  changeStatus: function(game_status) {
    $('#status > span').text(game_status);
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
      alert(JSON.parse(response.responseText).message);
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
      } else if (data.status === 'finished') {
        Game.finish(data);
      } else {
        console.log('i dont understant this status' + data.status);
      }
    },
  }
);
