require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'put /rooms/:id' do
    context 'failure cases' do
      it 'should reject a request if not logged in' do
        last_room = Room.last
        put :update, params: {
          room: {
            name: 'CHANGED-NAME',
            video_url: 'CHANGED-URL',
            room_type: 'closed'
          },
          id: last_room.id
        }
        last_room = Room.last
        expect(last_room.name).not_to eq('CHANGED-NAME')
        expect(last_room.video_url).not_to eq('CHANGED-URL')
        expect(last_room.room_type).not_to eq('closed')
      end

      it 'should reject a request if not room owner' do
        last_room = Room.last
        owner = RoomUser.find_by(room: last_room, role: 'owner').user
        non_owner = (User.all.to_a - [owner]).sample
        sign_in non_owner
        put :update, params: {
          room: {
            name: 'CHANGED-NAME',
            video_url: 'CHANGED-URL',
            room_type: 'closed'
          },
          id: last_room.id
        }
        last_room = Room.last
        expect(last_room.name).not_to eq('CHANGED-NAME')
        expect(last_room.video_url).not_to eq('CHANGED-URL')
        expect(last_room.room_type).not_to eq('closed')
      end
    end

    context 'success cases' do
      it 'should allow room owner to update room' do
        last_room = Room.last
        owner = RoomUser.find_by(room: last_room, role: 'owner').user
        sign_in owner
        put :update, params: {
          room: {
            name: 'CHANGED-NAME',
            video_url: 'CHANGED-URL',
            video_token: {test: 'test'}.to_json,
            room_type: 'closed'
          },
          id: last_room.id
        }
        last_room = Room.last
        expect(last_room.name).to eq('CHANGED-NAME')
        expect(last_room.video_url).to eq('CHANGED-URL')
        expect(last_room.video_token).to eq({test: 'test'}.to_json)
        expect(last_room.room_type).to eq('closed')
      end
    end
  end

  describe 'show /rooms/:id' do
    context 'success cases' do
      it 'should create a new RoomUser if user visits room for first time' do
        room_user_count_before = RoomUser.count
        user = User.create(email: 'user999@vtchat.com', password: 'password')
        last_room = Room.last
        sign_in user
        get :show, params: {
          id: last_room.id
        }
        room_user_count_after = RoomUser.count
        expect(room_user_count_after).to eq(room_user_count_before + 1)
        last_room_user = RoomUser.last
        expect(last_room_user.user).to eq(user)
        expect(last_room_user.room).to eq(last_room)
        expect(last_room_user.role).to eq('guest')
        get :show, params: {
          id: last_room.id
        }
        expect(RoomUser.count).to eq(room_user_count_after)
      end
    end
  end

  describe 'post /rooms' do
    context 'failure cases' do
      it 'should reject a request if not logged in' do
        room_count_before = Room.count
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
        room_user_count_before = RoomUser.count
        user = User.all.sample
        sign_in user
        post :create, params: {
          room: {
            name: 'aldkjfalskdfjalsdf',
            video_url: 'http://guides.rubyonrails.org',
            video_token: 'alsdkfjasldkfj'
          }
        }
        expect(Room.count).to eq(room_count_before + 1)
        last_room = Room.last
        expect(last_room.name).to eq('aldkjfalskdfjalsdf')
        expect(last_room.video_url).to eq('http://guides.rubyonrails.org')
        expect(last_room.video_token).to eq('alsdkfjasldkfj')
        expect(last_room.room_type).to eq('open')
        expect(RoomUser.count).to eq(room_user_count_before + 1)
        last_room_user = RoomUser.last
        expect(last_room_user.user).to eq(user)
        expect(last_room_user.room).to eq(last_room)
        expect(last_room_user.role).to eq('owner')
      end

      it 'should automatically create a video_url if room is closed' do
        room_count_before = Room.count
        room_user_count_before = RoomUser.count
        user = User.all.sample
        sign_in user
        post :create, params: {
          room: {
            name: 'aldkjfalskdfja2342342lsdf',
            room_type: 'closed'
          }
        }
        expect(Room.count).to eq(room_count_before + 1)
        last_room = Room.last
        expect(last_room.name).to eq('aldkjfalskdfja2342342lsdf')
        expect(last_room.video_url).not_to be_nil
        expect(last_room.room_type).to eq('closed')
        expect(RoomUser.count).to eq(room_user_count_before + 1)
        last_room_user = RoomUser.last
        expect(last_room_user.user).to eq(user)
        expect(last_room_user.room).to eq(last_room)
        expect(last_room_user.role).to eq('owner')
      end
    end
  end
end
