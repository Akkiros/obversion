var Game = {
  join: function(response) {
    console.log('join');
    if (response.current_player_count == 1) {
      $('#first_player > .player_id').text(response.player_id);
    } else {
      $('#last_player > .player_id').text(response.player_id);
    }
  },
  leave: function(response) {
    console.log('leave');
    // 0명일땐 방 폭파
    if (response.current_player_count == 1) {
      $('#first_player > .player_id').text(response.active_player_ids[0]);
      $('#last_player > .player_id').text('not yet');
    }
  },
  start: function(response) {
    console.log('start');
  }
}
App.messages = App.cable.subscriptions.create({ channel: 'GameChannel', game_id: $("#game_id").val() }, {
  received: function(data) {
    console.log('received');
    console.log(data);
    if (data.status === 'join') {
      Game.join(data);
    } else if (data.status === 'leave') {
      Game.leave(data);
    } else if (data.status === 'start') {
      Game.start(data);
    } else {
      console.log('i dont understant this status' + data.status);
    }
  },
});
