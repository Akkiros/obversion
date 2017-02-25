var Game = {
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

    $('#status > span').text(response.status);

    remain_time = response.remain_time;
    $('#remain_time > #count').text(remain_time);

    interval = setInterval(tick, 1000);

    function tick() {
      console.log(remain_time);
      remain_time -= 1;

      if (remain_time <= 0) {
        clearInterval(interval);
      }

      $('#remain_time > #count').text(remain_time);

    }
  }
}

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
      } else {
        console.log('i dont understant this status' + data.status);
      }
    },
  }
);
