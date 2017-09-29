require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
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
end
