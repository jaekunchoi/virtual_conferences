class ContentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :set_venue
  before_action :role_vars
  before_action :sidebar_menu

  include AuthHelper
  
  helper_method :view_type
  helper_method :available_booths
  helper_method :available_halls
  helper_method :available_users
  helper_method :get_venues, :available_tags
  helper_method :new_path, :index_path

  def new_path
    @venue.present? ? new_venue_content_path(@venue) : new_content_path()
  end
  
  def index_path
    @venue.present? ? venue_contents_path(@venue) : contents_path()
  end

  def index
    if(current_user.has_role?(:admin) || current_user.has_role?(:vendor))
      if (@venue)
        @contents = Content.where(venue: @venue)
      else
        @contents = Content.all
      end 
    else
      @contents = Content.where(:owner_user_id => current_user.id)
    end
  end

  def show
  end

  def new
    @content = Content.new()
    @content.owner_user = current_user
    if current_user.booths.size == 1 && current_user.has_role?(:booth_rep)
      @content.booths << current_user.booths.first
    end
    @content.venue = @venue
    #Extract the venue from the user's venues - for booth reps
    current_user.booths.each {|booth| @content.venue ||= booth.hall.venue if booth.hall} if @content.venue.nil?
    @content.build_resource_file unless @content.resource_file
    @content.build_thumbnail_image unless @content.thumbnail_image
  end

  def create
    @content = Content.new(content_params)
    clenseContent()
    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Content was successfully created.' }
        format.json { render action: 'show', status: :created, location: @content }
      else
        flash[:error] = 'Unable to create content. ' + @content.errors.full_messages.to_s
        format.html { render action: 'new' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @content.build_resource_file unless @content.resource_file
    @content.build_thumbnail_image unless @content.thumbnail_image
  end

  def update
    @content.assign_attributes(content_params)
    clenseContent()
    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Content was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @content }
      else
        flash[:error] = 'Unable to update content. ' + @content.errors.full_messages.to_s
        format.html { render action: 'new'}
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_path() }
      format.json { head :no_content }
    end
  end
  
  def clenseContent()
    case @content.content_type
      when Content::CONTENT_TYPE[:youtube_video]
        return if @content.external_id.nil?
        matches = @content.external_id.match(/v=(\w+)/)
        return if matches.nil? or matches.size < 2
        yt_id = @content.external_id.match(/v=(\w+)/)[1]
        if yt_id.present?
          @content.external_id = yt_id
        end
      when Content::CONTENT_TYPE[:slideshare]
        
    end
  end
  

  def preview
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def view
    respond_to do |format|
      format.html { render layout: false }
    end
  end
  
  def get_venues
    @venues ||= Venue.all if view_type.include?(:admin)
    @venues ||= @venue unless view_type.include?(:admin)
  end
  
  def view_type
    if @view_type_obj.nil?
      @view_type_obj = get_view_type()
    end
    @view_type_obj
  end

  def available_booths
    if current_user.has_role? :admin
      booths = []
      if @venue
        @venue.halls.each{|hall| hall.booths.each {|booth| booths << booth if !booths.include?(booth)} }
      end
      booths
    else
      Booth.where("user_id = ? OR id in (SELECT booth_id FROM booths_contents WHERE content_id = ?)", current_user.id, @content.id)
    end
  end

  def available_halls
    if current_user.has_role? :admin
      if @venue
        @venue.halls.select{|hall| hall.knowledge_hall? }
      else
        []
      end
    else
      #won't be called
      #Hall.where("owner_id = ? OR id in (SELECT hall_id FROM contents_halls WHERE content_id = ?)", current_user.id, @content.id).select{|hall| hall.knowledge_hall? }
    end
  end
  def available_tags
    if @venue
      @venue.tags
    else
      []
    end
  end
  
  def available_users
    if current_user.has_role? :admin
      User.all
    else
      User.where(:id => current_user.id)
    end
  end
  
private
  
  def set_content
    @content = Content.find(params[:id])
  end

  def set_venue
    @venue = @content.venue if @content
    @venue ||= Venue.find(params[:venue_id]) if params[:venue_id]
  end

  def content_params
    local_params = params.require(:content).permit(:name, :content_type, :external_id, :short_desc, :description,
      :sponsor_booth_id, :featured, :owner_user_id, :resource_file, :venue_id,
      tag_ids: [], booth_ids: [], hall_ids: [], thumbnail_image_attributes: [:assets])
    
    #this bit hacks the resource file saving so that it works properly, as it is stored in a different spot to where it is expected.
    if local_params[:resource_file].present?
      local_params[:resource_file_attributes] = {assets: local_params[:resource_file]}
      local_params.delete(:resource_file)
    end
    local_params
  end

  def role_vars
    if current_user.has_role? :booth_rep
      hide_sidebar 'hide-sidebar'
    end
  end
end