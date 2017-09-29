class MessagesChannel < ApplicationCable::Channel
  # subscribe to and stream messages that are broadcast
  def subscribed
    puts "\n\n\nSUBSCRIBED!\n\n\n"
    # this method is invoked when a subscription is created
    # it will create a stream of JSON data which is sent to our client
    stream_from 'messages'
  end
end
