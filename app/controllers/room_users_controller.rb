class RoomUsersController < ApplicationController
  before_action :set_room_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
  end

  def new
    @room_user = RoomUser.new
  end

  def edit
  end

  def create
    room = Room.find(room_user_params[:room_id])

    if room.closed? && room.room_users.count >= 2
      redirect_to rooms_path
      return
    end

    @room_user = RoomUser.new(room_user_params)

    owner_room_user = RoomUser.find_by(room_id: @room_user.room_id, user: current_user)

    unless owner_room_user && owner_room_user.owner?
      redirect_to rooms_path
      return
    end

    respond_to do |format|
      if @room_user.save
        format.html { redirect_to @room_user.room, notice: 'RoomUser was successfully created.' }
        format.json { render :show, status: :created, location: @room_user.room }
      else
        format.html { render :new }
        format.json { render json: @room_user.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path
    return
  end

  def update
    respond_to do |format|
      room_id = room_user_params[:room_id] || @room_user.room_id
      room_user = RoomUser.find_by(room_id: room_id, user: current_user)
      unless room_user && room_user.owner?
        redirect_to rooms_path
        return
      end
      if @room_user.update(room_user_params)
        format.html { redirect_to @room_user.room, notice: 'RoomUser was successfully updated.' }
        format.json { render :show, status: :ok, location: @room_user.room }
      else
        format.html { render :edit }
        format.json { render json: @room_user.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path
    return
  end

  def destroy
    unless @room_user.user == current_user
      room_user = RoomUser.find_by(room_id: @room_user.room_id, user: current_user)
      unless room_user && room_user.owner?
        redirect_to rooms_url
        return
      end
    end

    @room_user.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_user
      @room_user = RoomUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_user_params
      params.require(:room_user).permit(
        :user_id,
        :room_id,
        :role
      )
    end
end
