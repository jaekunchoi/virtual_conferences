class ModeratedChatsController < ApplicationController
  before_action :set_moderated_chat, only: [:show, :edit, :update, :destroy]
  before_action :sidebar_menu

  # GET /moderated_chats
  def index
    @moderated_chats = ModeratedChat.all
  end

  # GET /moderated_chats/1
  def show
  end

  # GET /moderated_chats/new
  def new
    @moderated_chat = ModeratedChat.new
  end

  # GET /moderated_chats/1/edit
  def edit
  end

  # POST /moderated_chats
  def create
    @moderated_chat = ModeratedChat.new(moderated_chat_params)
    respond_to do |format|
      if @moderated_chat.save
        sync_new @moderated_chat
        format.html{ redirect_to @moderated_chat, notice: 'Moderated chat was successfully created.' }
        format.js
      else
        format.html{ render action: 'new' }
        format.js
      end
    end
  end

  # PATCH/PUT /moderated_chats/1
  def update
    respond_to do |format|
      if @moderated_chat.update(moderated_chat_params)
        sync_update @moderated_chat
        format.html{ redirect_to @moderated_chat, notice: 'Moderated chat was successfully updated.' }
        format.js
      else
        format.html{ render action: 'edit' }
        format.js
      end
    end
  end

  # DELETE /moderated_chats/1
  def destroy
    @moderated_chat.destroy
    sync_destroy @moderated_chat
    respond_to do |format|
      format.html{ redirect_to moderated_chats_url, notice: 'Moderated chat was successfully destroyed.' }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moderated_chat
      @moderated_chat = ModeratedChat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def moderated_chat_params
      params.require(:moderated_chat).permit(:message, :webcast_id, :from_user_id, :to_user_id, :approved)
    end

    def sidebar_menu
      super ["Q&A Chats", "comments-o"], "chats-nav", [[moderated_chats_path, "List chats"], [new_moderated_chat_path(@chat), "Create a chat"]], true if current_user.has_role? :admin
    end
end
