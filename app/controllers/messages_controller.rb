class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.where(room_id: params[:id])
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    puts "\n\n\nIN THE MESSAGE CREATE METHOD\n\n\n"
    puts "\n\n\nmessage_params: #{message_params.inspect}\n\n\n"
    message = Message.new(message_params)
    message.user = current_user
    puts "new message: #{message.inspect}"
    if message.save
      puts "\nI SHOULD BE PUSHED\n"
      # broadcast message to the 'messages' stream
      # the stream is then passed along to Redis
      ActionCable.server.broadcast 'messages',
        message: message.content,
        user: message.user.email
      head :ok
    else
      redirect_to chatrooms_path
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(
        :user_id,
        :room_id,
        :content
      )
    end
end
