var Game = {
  init: function() {
    console.log('init');

    var game_size = 10;
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
    console.log('joined');

    if (response.current_player_count == 1) {
      $('#first_player > .player_id').text(response.player_id);
    } else {
      $('#last_player > .player_id').text(response.player_id);
    }
  },
  leave: function(response) {
    console.log('leaved');

    // 0명일땐 방 폭파
    if (response.current_player_count == 1) {
      $('#first_player > .player_id').text(response.active_player_ids[0]);
      $('#last_player > .player_id').text('not yet');
    }
  },
  start: function(response) {
    console.log('started');

    this.changeStatus(response.status);

    remain_time = response.remain_time;
    $('#remain_time > #count').text(remain_time);

    // TODO : 이 부분 서버로 이동
    interval = setInterval(tick, 1000);

    function tick() {
      console.log(remain_time);
      remain_time -= 1;

      if (remain_time <= 0) {
        clearInterval(interval);
      }

      $('#remain_time > #count').text(remain_time);
    }
  },
  play: function(response) {
    console.log(response);
    $('.game_board > .tiles:eq(' + response.game_data.x + ') > .tile:eq(' + response.game_data.y + ')').css('background', response.color);
  },
  finish: function(response) {
    this.changeStatus(response.status);
  },
  changeStatus: function(game_status) {
    $('#status > span').text(game_status);
  }
}

Game.init();

$('.game_board > .tiles > .tile').click(function() {
  console.log(this);
  var _this = this;
  $.ajax({
    method: 'POST',
    url: '/games/click',
    data: {
      game_id: $('#game_id').val(),
      x: $(_this).data('x'),
      y: $(_this).data('y')
    },
    // fail 체크
    success: function(response) {
      console.log(response);
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
      console.log('received');
      console.log(data);
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
