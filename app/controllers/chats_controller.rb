class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]
  before_action :sidebar_menu

  # GET /chats
  def index
    @chats = Chat.all
  end

  # GET /chats/1
  def show
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats
  def create
    @chat = Chat.new(chat_params)
    respond_to do |format|
      if @chat.save
        sync_new @chat
        format.html{ redirect_to @chat, notice: 'Chat was successfully created.' }
        format.js
      else
        format.html{ render action: 'new' }
        format.js
      end
    end
  end

  # PATCH/PUT /chats/1
  def update
    if @chat.update(chat_params)
      sync_update @chat
      redirect_to @chat, notice: 'Chat was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /chats/1
  def destroy
    @chat.destroy
    sync_destroy @chat
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Chat was successfully destroyed.' }
      format.js
    end
  end

  def read_all_booth_user_chats
    Chat.read_all_booth_user_chats current_user.booths.first.id
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.require(:chat).permit(:from_user_id, :to_user_id, :message, :chattable_type, :chattable_id, :qna, :approved)
    end

    def sidebar_menu
      super ["Chats", "comments-o"], "chats-nav", [[chats_path, "List chats"], [new_chat_path(@chat), "Create a chat"]], true if current_user.has_role? :admin
    end
end
