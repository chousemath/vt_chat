require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'post /rooms' do
    context 'failure cases' do
      it 'should reject a request if not logged in' do
        room_count_before = User.count
        post :create, params: {
          room: {
            # name: 'aldkjfalskdfjalsdf',
            video_url: 'http://guides.rubyonrails.org'
          }
        }
        expect(Room.count).to eq(room_count_before)
      end

      it 'should reject a request without a room name' do
        room_count_before = Room.count
        user = User.all.sample
        sign_in user
        post :create, params: {
          room: {
            # name: 'aldkjfalskdfjalsdf',
            video_url: 'http://guides.rubyonrails.org'
          }
        }
        # expect(response).to be_successful
        expect(response).to render_template(:new)
        expect(Room.count).to eq(room_count_before)
      end
    end

    context 'success cases' do
      it 'should create a room if logged in, all attributes present' do
        room_count_before = Room.count
        user = User.all.sample
        sign_in user
        post :create, params: {
          room: {
            name: 'aldkjfalskdfjalsdf',
            video_url: 'http://guides.rubyonrails.org'
          }
        }
        expect(Room.count).to eq(room_count_before + 1)
      end
    end
  end
end
