App.messages = App.cable.subscriptions.create({ channel: 'GameChannel', game_id: $("#game_id").val() }, {
  received: function(data) {
    console.log('received');
    console.log(data);
    //$("#messages").removeClass('hidden')
      //return $('#messages').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    return "<p> <b>" + data.user + ": </b>" + data.message + "</p>";
  }
});
