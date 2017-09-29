//= require cable
//= require_self
//= require_tree .

this.App = {};

// the consumer is the client-side end of the persistent WebSocket connection
App.cable = ActionCable.createConsumer();
// need to add subscription, telling consumer to subscribe to MessagesChannel
