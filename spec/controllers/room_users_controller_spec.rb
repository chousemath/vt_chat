require 'rails_helper'

RSpec.describe RoomUsersController, type: :controller do
  describe 'put /room_users/:id' do
    context 'failure cases' do
      it 'should reject a request if not logged in' do
        last_room_user = RoomUser.last
        room = last_room_user.room
        user = last_room_user.user
        different_room = (Room.all.to_a - [room]).sample
        different_user = (User.all.to_a - [user]).sample
        put :update, params: {
          room_user: {
            room_id: different_room.id,
            user_id: different_user.id
          },
          id: last_room_user.id
        }
        last_room_user = RoomUser.last
        expect(last_room_user.room_id).not_to eq(different_room.id)
        expect(last_room_user.user_id).not_to eq(different_user.id)
      end

      it 'should reject a request if not room owner (room_id in request' do
        last_room_user = RoomUser.last
        room = last_room_user.room
        user = last_room_user.user
        different_room = (Room.all.to_a - [room]).sample
        different_user = (User.all.to_a - [user]).sample
        owner = RoomUser.find_by(room: different_room, role: 'owner').user
        non_owner = (User.all.to_a - [owner]).sample
        sign_in non_owner
        put :update, params: {
          room_user: {
            room_id: different_room.id,
            user_id: different_user.id
          },
          id: last_room_user.id
        }
        last_room_user = RoomUser.last
        expect(last_room_user.room_id).not_to eq(different_room.id)
        expect(last_room_user.user_id).not_to eq(different_user.id)
      end

      it 'should reject a request if not room owner' do
        last_room_user = RoomUser.last
        room = last_room_user.room
        user = last_room_user.user
        different_user = User.create!(
          email: 'sdfsdf8sdf@vtchat.com',
          password: 'password'
        )
        owner = RoomUser.find_by(room: room, role: 'owner').user
        non_owner = (User.all.to_a - [owner]).sample
        sign_in non_owner
        put :update, params: {
          room_user: {
            user_id: different_user.id
          },
          id: last_room_user.id
        }
        last_room_user = RoomUser.last
        expect(last_room_user.user_id).not_to eq(different_user.id)
      end
    end

    context 'success cases' do
      it 'should update a RoomUser if logged in and room owner' do
        last_room_user = RoomUser.last
        room = last_room_user.room
        user = last_room_user.user
        different_user = User.create!(
          email: 'fdfdf777s7@vtchat.com',
          password: 'password'
        )
        owner = RoomUser.find_by(room: room, role: 'owner').user
        sign_in owner
        put :update, params: {
          room_user: {
            user_id: different_user.id
          },
          id: last_room_user.id
        }
        last_room_user = RoomUser.last
        expect(last_room_user.user_id).to eq(different_user.id)
      end

      it 'should update a RoomUser if logged in and next room owner' do
        last_room_user = RoomUser.last
        room = last_room_user.room
        user = last_room_user.user
        different_room = (Room.all.to_a - [room]).sample

        different_user = User.create!(
          email: 'jlakdsjfksjdfksf@vtchat.com',
          password: 'password'
        )

        owner = RoomUser.find_by(room: different_room, role: 'owner').user

        sign_in owner
        put :update, params: {
          room_user: {
            room_id: different_room.id,
            user_id: different_user.id
          },
          id: last_room_user.id
        }

        puts "\n\nDIFFERENT ROOM ID: #{different_room.id}\n\n"
        puts "\n\nLAST ROOM ID: #{last_room_user.room_id}\n\n"

        last_room_user = RoomUser.last
        expect(last_room_user.room_id).to eq(different_room.id)
        expect(last_room_user.user_id).to eq(different_user.id)
      end
    end

    describe 'post /room_users' do
      context 'failure cases' do
        it 'should reject a request if not logged in' do
          room_user_count_before = RoomUser.count
          room = Room.last
          owner = RoomUser.find_by(room: room, role: 'owner').user
          non_owner = (User.all.to_a - [owner]).sample
          post :create, params: {
            room_user: {
              room_id: room.id,
              user_id: non_owner.id
            }
          }
          expect(RoomUser.count).to eq(room_user_count_before)
        end

        it 'should reject a request if logged in, but not room owner' do
          room_user_count_before = RoomUser.count
          room = Room.last
          owner = RoomUser.find_by(room: room, role: 'owner').user
          non_owner = (User.all.to_a - [owner]).sample
          sign_in non_owner
          post :create, params: {
            room_user: {
              room_id: room.id,
              user_id: non_owner.id
            }
          }
          expect(RoomUser.count).to eq(room_user_count_before)
        end

        it 'should reject a request without room_id' do
          room_user_count_before = RoomUser.count
          room = Room.last
          owner = RoomUser.find_by(room: room, role: 'owner').user
          non_owner = (User.all.to_a - [owner]).sample
          sign_in owner
          post :create, params: {
            room_user: {
              # room_id: room.id,
              user_id: non_owner.id
            }
          }
          expect(RoomUser.count).to eq(room_user_count_before)
        end

        it 'should reject a request without user_id' do
          room_user_count_before = RoomUser.count
          room = Room.last
          owner = RoomUser.find_by(room: room, role: 'owner').user
          non_owner = (User.all.to_a - [owner]).sample
          sign_in owner
          post :create, params: {
            room_user: {
              room_id: room.id
              # user_id: non_owner.id
            }
          }
          expect(RoomUser.count).to eq(room_user_count_before)
        end

        it 'should reject a request if room is closed and already 2 relationships' do
          room = Room.create!(name: 'kjk8234jljsdf77fsdf', room_type: 'closed')
          expect(room.name).to eq('kjk8234jljsdf77fsdf')
          expect(room.room_type).to eq('closed')
          owner = User.first
          non_owner = User.second
          other = User.third
          RoomUser.create!(room: room, user: owner, role: 'owner')
          RoomUser.create!(room: room, user: non_owner, role: 'guest')
          room_user_count_before = room.room_users.count
          expect(room_user_count_before).to eq(2)
          post :create, params: {
            room_user: {
              room_id: room.id,
              user_id: other.id
            }
          }
          expect(room.room_users.count).to eq(room_user_count_before)
        end
      end

      context 'success cases' do
        it 'should reject a request if logged in, but not room owner' do
          room_user_count_before = RoomUser.count
          room = Room.last
          owner = RoomUser.find_by(room: room, role: 'owner').user
          non_owner = (User.all.to_a - [owner]).sample
          sign_in owner
          post :create, params: {
            room_user: {
              room_id: room.id,
              user_id: non_owner.id
            }
          }
          expect(RoomUser.count).to eq(room_user_count_before)
        end
      end
    end

    describe 'delete /room_users/:id' do
      context 'failure cases' do
        it 'should reject a request if not logged in' do
          room_user_count_before = RoomUser.count
          room = Room.last
          owner = RoomUser.find_by(room: room, role: 'owner').user
          non_owner_room_user = RoomUser.where(room: room, role: 'guest').sample
          delete :destroy, params: {id: non_owner_room_user.id}
          expect(RoomUser.count).to eq(room_user_count_before)
        end

        it 'should not allow a user to delete another users room_user' do
          room_user_count_before = RoomUser.count
          room = Room.last
          owner = RoomUser.find_by(room: room, role: 'owner').user
          non_owner_room_user = RoomUser.find_by(room: room, role: 'guest')
          other_user = (User.all.to_a - [owner, non_owner_room_user.user]).sample
          sign_in other_user
          delete :destroy, params: {id: non_owner_room_user.id}
          expect(RoomUser.count).to eq(room_user_count_before)
        end
      end

      context 'success cases' do
        it 'should allow a user to destroy their own room_user' do
          room_user_count_before = RoomUser.count
          room = Room.last
          owner = RoomUser.find_by(room: room, role: 'owner').user
          non_owner_room_user = RoomUser.find_by(room: room, role: 'guest')
          non_owner = non_owner_room_user.user
          room_user = RoomUser.find_by(room: room, user: non_owner)
          sign_in non_owner
          delete :destroy, params: {id: non_owner_room_user.id}
          expect(RoomUser.count).to eq(room_user_count_before - 1)
        end
      end
    end
  end
end
