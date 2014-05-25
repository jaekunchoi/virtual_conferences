class UploadedFilesController < ApplicationController
	before_filter :authenticate_user!
  	load_and_authorize_resource :except => [:show]
  	skip_load_resource :only => [:create]
	before_action :set_uploaded_file, only: [:show, :edit, :update, :destroy]

	def index
		@uploaded_files = UploadedFile.all
	end

	def edit
	end

	def show
		render json: @uploaded_file
	end

	def create
		@uploaded_file = UploadedFile.new(user_params)
	    if @uploaded_file.save
	    	respond_with @uploaded_file
	    else
	    	render json: { errors: @uploaded_file.errors }, status: :unprocessable_entry
	    end
	end

	def update
		if params[:uploaded_file][:password].blank?
		  params[:uploaded_file].delete(:password)
		  params[:uploaded_file].delete(:password_confirmation)
		end
		if @uploaded_file.update(uploaded_file_params)
			head :no_content
		else
			render json: @uploaded_file.errors, status: :unprocessable_entry	
		end
	end

	def destroy
		@uploaded_file.destroy
		head :no_content
	end


	private

	def set_uploaded_file
		@uploaded_file = UploadedFile.find(params[:id])
	end

	def uploaded_file_params
		params.require(:uploaded_file).permit(:file_file_name, :file_content_type, :file_file_size, :assets)
	end
end
