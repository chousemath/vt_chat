// here we add a new subscription to our consumer (in rooms.js)
// we pass the name of the channel to which the consumer should subscribe
// (in this case, it is MessagesChannel)
App.messages = App.cable.subscriptions.create('MessagesChannel', {
  // when the this create function is invoked, it will invoke the
  // MessagesChannel#subscribed method (which is a callback)
  received: function(data) {
    console.log('received!');
    // this method is called after the MessagesChannel#subscribed method is
    // invoked, it is given the new JSON data
    $("#messages").removeClass('hidden')
    // append the new message to the DOM using a helper method
    return $('#messages').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    console.log('RENDER MESSAGE HAS BEEN ACTIVATED');
    return "<p> <b>" + data.user + ": </b>" + data.message + "</p>";
  }
});
