require 'rails_helper'

RSpec.describe MessagesController, type: :controller do

  describe 'delete /messages' do
    context 'failure cases' do
      it 'should reject a request if not logged in' do
        message_count_before = Message.count
        delete :destroy, params: {
          id: Message.last.id
        }
        expect(Message.count).to eq(message_count_before)
      end

      it 'should reject a request if message not created by user' do
        message_count_before = Message.count
        last_message = Message.last
        owner = last_message.user
        non_owner = (User.all.to_a - [owner]).sample
        sign_in non_owner
        delete :destroy, params: {
          id: Message.last.id
        }
        expect(response).to redirect_to(last_message.room)
        expect(Message.count).to eq(message_count_before)
      end
    end

    context 'success cases' do
      it 'should allow the owner of message to delete it' do
        message_count_before = Message.count
        last_message = Message.last
        owner = last_message.user
        sign_in owner
        delete :destroy, params: {
          id: Message.last.id
        }
        expect(Message.count).to eq(message_count_before - 1)
      end
    end
  end

  describe 'put /messages' do
    context 'failure cases' do
      it 'should reject a request if not logged in' do
        last_message = Message.last
        last_message_content = last_message.content
        put :update, params: {
          message: {
            content: 'changed'
          },
          id: last_message.id
        }
        expect(Message.last.content).to eq(last_message_content)
      end

      it 'should reject request if message does not belong to current user' do
        last_message = Message.last
        last_message_content = last_message.content
        owner = last_message.user
        non_owner = (User.all.to_a - [owner]).sample
        sign_in non_owner
        put :update, params: {
          message: {
            content: 'changed'
          },
          id: last_message.id
        }
        expect(Message.last.content).to eq(last_message_content)
        expect(response).to redirect_to(last_message)
      end
    end

    context 'success cases' do
      it 'should allow message creator to update a message' do
        last_message = Message.last
        last_message_content = last_message.content
        owner = last_message.user
        sign_in owner
        put :update, params: {
          message: {
            content: 'changed'
          },
          id: last_message.id
        }
        expect(Message.last.content).to eq('changed')
      end
    end
  end

  describe 'post /messages' do
    context 'failure cases' do
      it 'should reject a request if not logged in' do
        message_count_before = Message.count
        post :create, params: {
          message: {
            content: 'changed',
            room_id: Room.last.id
          }
        }
        expect(Message.count).to eq(message_count_before)
      end

      it 'should reject a request if there is no content' do
        message_count_before = Message.count
        user = User.last
        sign_in user
        post :create, params: {
          message: {
            # content: 'changed',
            room_id: Room.last.id
          }
        }
        expect(Message.count).to eq(message_count_before)
      end

      it 'should reject a request if there is no content' do
        message_count_before = Message.count
        user = User.last
        sign_in user
        post :create, params: {
          message: {
            content: 'changed'
            # room_id: Room.last.id
          }
        }
        expect(Message.count).to eq(message_count_before)
      end
    end

    context 'success cases' do
      it 'should create a message if logged in and request has all attributes' do
        message_count_before = Message.count
        user = User.last
        sign_in user
        post :create, params: {
          message: {
            content: 'changed',
            room_id: Room.last.id
          }
        }
        expect(Message.count).to eq(message_count_before + 1)
      end
    end
  end
end
