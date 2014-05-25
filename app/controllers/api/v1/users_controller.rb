module Api::V1
  class UsersController < ApplicationController
    protect_from_forgery with: :null_session
    
    before_filter :authenticate_user!
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    respond_to :json

    def dashboard
    end

    def index
      respond_with User.all
    end

    def show
      respond_with @user
    end

    def create
      @user = User.new(user_params)
        if @user.save
          respond_with @user
        else
          render json: { errors: @user.errors }, status: :unprocessable_entry
        end
    end

    def update
      if @user.update(user_params)
        head :no_content
      else
        respond_with @user.errors, status: :unprocessable_entry 
      end
    end

    def destroy
      @user.destroy
      head :no_content
    end


    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password, 
          :title, :first_name, :last_name, :position, :work_phone, :company)
    end
    
  end
end