// here we add a new subscription to our consumer (in rooms.js)
// we pass the name of the channel to which the consumer should subscribe
// (in this case, it is MessagesChannel)
App.messages = App.cable.subscriptions.create('MessagesChannel', {
  // when the this create function is invoked, it will invoke the
  // MessagesChannel#subscribed method (which is a callback)
  received: function(data) {
    // this method is called after the MessagesChannel#subscribed method is
    // invoked, it is given the new JSON data
    $("#messages").removeClass('hidden')
    // append the new message to the DOM using a helper method
    $('#messages').append(this.renderMessage(data));
    // scroll to the bottom of the list
    window.setTimeout(function() {
      $('#message-container').animate({scrollTop: $('#message-container').prop("scrollHeight")}, 100);
    }, 200);
    return;
  },
  renderMessage: function(data) {
    // insert the list element that Gunhee designed
    return '<li class="mdl-list__item mdl-list__item--three-line"> <span class="mdl-list__item-primary-content"> <i class="material-icons mdl-list__item-avatar">person</i> <span>' + data.user + '</span> <span class="mdl-list__item-text-body">' + data.message + '</span> </span> </li>';
  }
});
