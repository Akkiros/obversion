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
    console.log(response);
  },
  start: function(response) {
    console.log(response);
  }
}
App.messages = App.cable.subscriptions.create({ channel: 'GameChannel', game_id: $("#game_id").val() }, {
  received: function(data) {
    console.log('received');
    console.log(data);
    if (data.status === 'join') {
      Game.join(data);
    }
    //$("#messages").removeClass('hidden')
      //return $('#messages').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    return "<p> <b>" + data.user + ": </b>" + data.message + "</p>";
  }
});
