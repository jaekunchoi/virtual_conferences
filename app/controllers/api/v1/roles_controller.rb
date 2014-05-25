module Api::V1
  class RolesController < ApplicationController
    protect_from_forgery with: :null_session

    before_action :set_role, only: [:show, :edit, :update, :destroy]

    respond_to :json
    def index
      respond_with Role.all
    end

    def show
      respond_with @role
    end

    def create
      @role = Role.new(user_params)
        if @role.save
          respond_with @role
        else
          render json: { errors: @role.errors }
        end
    end

    def update
      if @role.update(role_params)
        head :no_content
      else
        respond_with @role.errors
      end
    end

    def destroy
      @role.destroy
      head :no_content
    end


    private

    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:role)
    end

  end
end
