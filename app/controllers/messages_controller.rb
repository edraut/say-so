class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_filter :cache_broadcasts
  after_filter :broadcast_to_client

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    render partial: 'show', locals: {message: @message}
  end

  # GET /messages/new
  def new
    @message = Message.new
    puts "In controller: #{@message.inspect}"
    render partial: 'new', locals: {message: @message}
  end

  # GET /messages/1/edit
  def edit
    render partial: 'edit', locals: {message: @message}
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    SendMessage.call(@message)
    if @message.persisted?
      render partial: 'show_with_wrapper', locals: {message: @message}
    else
      render partial: 'form', locals: {message: @message}
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
      params.require(:message).permit(:body)
    end

    def cache_broadcasts
      ForeignOffice.cache_messages
    end

    def broadcast_to_client
      ForeignOffice.flush_messages
    end
end
