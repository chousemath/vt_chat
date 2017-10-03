class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @message = Message.new
    room_user = RoomUser.find_by(room: @room, user: current_user)
    unless room_user
      unless RoomUser.create(room: @room, user: current_user)
        redirect_to rooms_path
      end
    end
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @room_types = [['Private', 'closed']]
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    respond_to do |format|
      if @room.save
        RoomUser.create(room: @room, user: current_user, role: 'owner')
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      room_user = RoomUser.find_by(room: @room, user: current_user)
      unless room_user && room_user.owner?
        redirect_to @room, notice: 'You are not authorized to do that'
        return
      end
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
        format.js   { render :layout => false }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
        format.js   { render :layout => false }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(
        :video_url,
        :video_token,
        :name,
        :room_type
      )
    end
end
