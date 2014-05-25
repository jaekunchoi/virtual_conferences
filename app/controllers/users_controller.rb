class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:invite_users]
  load_and_authorize_resource :except => [:show, :invite_users]
  skip_load_resource :only => [:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :csv_export_status
  before_action :sidebar_menu, except: [:dashboard]
    
  helper_method :getLocationsMap
  include AuthHelper

  def index
    respond_to do |format|
      format.html
      format.json { render json: UsersDatatable.new(view_context) }
      format.js {
        job_id = UsersExport.create(:current_user_id => current_user.id)
        set_job_id job_id
      }
    end
  end

  def edit
    @user.build_uploaded_file unless @user.uploaded_file
  end

  def new
    @user.build_uploaded_file
    @action = "new"
  end

  def show
    @view_type = get_view_type_user(@user)
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save()
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_user
    @action = "new"
    @user = User.new(user_params)

    respond_to do |format|
      #We have to manually do this as devise has some issues where the validations break saving a user.
      if @user.password != @user.password_confirmation
        format.html { flash[:error] = 'Password and password confirmation must be identical.'
                      render action: 'new' }
      elsif User.exists?(email: @user.email)
        format.html { flash[:error] = 'Email address must be unique.'
                      render action: 'new' }
      elsif @user.save(validate: false)
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    onDashboardChange = (@user.status != user_params[:status])
      
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to((onDashboardChange ? root_path() : @user), notice: 'User was successfully updated.') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def dashboard
    if current_user.has_role? :admin
      @venues = Venue.all
    else
      @venues = Venue.find(current_user.id)
    end
    @venues = @venues.pluck(:name, :id)
  end

  # Update users worker action
  def update_users
    job_id = UserJob.create
    render :text => "Users being updated job id - #{job_id}"
  end

  def export_users_to_csv_by_event
    job_id = UsersExport.create(:event_id => params[:user][:event_ids], :current_user_id => current_user.id)
    set_job_id job_id
    respond_to do |format|
      format.js
    end
  end

  def export_attendees
    @users = User.where("current_sign_in_at > '2014-02-25' OR booth_closed_message = '1'")
    respond_to do |format|
      format.html
      format.csv { 
        send_data @users.to_csv 
      }
    end
  end

  def getLocationsMap()
    return User::LOCATIONS
  end
  
  def import_new
  end
  
  def import_process
    importFile = params[:importFile]
    fileContent = importFile.read
    importFile.close
    
    job_id = UsersImport.create(:import_file => fileContent, :current_user_id => current_user.id)
    set_job_id job_id
    respond_to do |format|
      format.html {redirect_to import_users_complete_path}
    end
  end
  
  def import_complete
  end

  private

    def set_user
      @user = User.find(params[:id])
      uploaded_file_url(@user)
    end

    def user_params
      params.require(:user).permit(:email, :encrypted_password, :password, :password_confirmation, :current_password, :status, :booth_closed_message,
    :title, :first_name, :last_name, :position, :work_phone, :mobile, :company, :state, :industry, :interested_topic, :skip_invitation, { uploaded_file_attributes: [:assets] }, 
          { csv_file_attributes: [:assets] }, { :role_ids => [] }, { :event_ids => [] }, { :booth_ids => [] }, :user_id)
    end

    def sidebar_menu
        super ["Users", "users"], "user-nav", [[users_path, "List users"], [new_user_path, "Create a user"], [new_user_invitation_path, "Invite user"], [import_users_path, "Import users"]], true
    end

    def uploaded_file_url(user)
      @avatar = user.uploaded_file.assets.url if user.uploaded_file
    end

    def set_job_id job_id
      session["job_id-#{current_user.id}"] = job_id
      csv_export_status
    end

    def csv_export_status 
      @csv_export_status = Resque::Plugins::Status::Hash.get(session["job_id-#{current_user.id}"]) if session["job_id-#{current_user.id}"]
    end

end
