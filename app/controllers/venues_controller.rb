class VenuesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]
  before_action :set_venue, only: [:show, :edit, :update, :destroy]
  before_action :sidebar_menu
  helper_method :view_type

  include AuthHelper

  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.all
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @halls = Hall.where(ancestry: nil, venue_id: @venue.id)
    add_sidebar_menu ["Chats", "comments-o"], "chats-nav", [[chats_path, "List chats"], [new_chat_path, "Create a chat"]], false if current_user.has_role? :admin
  end

  # GET /venues/new
  def new
    @venue = Venue.new
    @venue.build_uploaded_file
    @venue.build_top_background
    @venue.build_background_image
    @venue.build_main_sponsor_logo
  end

  # GET /venues/1/edit
  def edit
    add_sidebar_menu ["Venue management", "map-marker"], "venue-mgmt-nav", 
            [[venues_dashboard_path, "Dashboard"],
            [venues_general_settings_path, "General settings"],
            [venue_venue_structure_path(@venue), "Venue structure"],
            [venues_networking_and_communication_path, "Networking & communications"],
            [venues_announcement_board_path, "Announcement board"],
            [venues_privacy_statement_path, "Privacy statement"]], false
    @venue.build_uploaded_file unless @venue.uploaded_file
    @venue.build_top_background unless @venue.top_background
    @venue.build_background_image unless @venue.background_image
    @venue.build_main_sponsor_logo unless @venue.main_sponsor_logo
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(venue_params)
    @venue.build_uploaded_file
    @venue.build_top_background
    @venue.build_background_image
    @venue.build_main_sponsor_logo
    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @venue }
      else
        format.html { render action: 'new' }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /venues/1
  # PATCH/PUT /venues/1.json
  def update
    respond_to do |format|
      if @venue.update(venue_params)
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue.destroy
    respond_to do |format|
      format.html { redirect_to venues_url }
      format.json { head :no_content }
    end
  end

  def dashboard
    if current_user.has_role? :admin
      @venues = Venue.all
    elsif current_user.has_role? :visitor
      @events = current_user.events
    elsif current_user.has_role? :booth_rep
      @booths = current_user.booths
      hide_sidebar 'hide-sidebar'
      render "dashboard_booth_rep"
    elsif current_user.has_role? :host
      @webcasts = current_user.webcasts
      hide_sidebar 'hide-sidebar'
    else
      @venues = current_user.venues
    end
  end

  def general_settings
  end

  def networking_and_communication
  end

  def announcement_board
  end

  def promotional_board
  end

  def privacy_statement
  end

  def venue_structure
    @halls = Hall.where(:hall_type => "Main", :venue_id => params[:venue_id])
  end

  def view_type
    if @view_type_obj.nil?
      @view_type_obj = get_view_type()
    end
    @view_type_obj
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue
      @venue = Venue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venue_params
      params.require(:venue).permit(:name, :user_id, :colour, :event_welcome_heading, :event_welcome_text, :sponsor_tagline,
        :whats_new, :personal_map, :display_webcast_rating, :display_other_content_rating, :closed_event_redirect,
        :display_on_demand_status, :display_original_broadcast_date, :venue_reports_url, :support_message, :venue_comments,
        {background_image_attributes: [:assets]}, {top_background_attributes: [:assets]}, {uploaded_file_attributes: [:assets]},
        {main_sponsor_logo_attributes: [:assets]}, :main_sponsor_url)
    end

    def twitter
      @client = Twitter::Streaming::Client.new do |config|
        config.consumer_key        = "irnj1j9xTlfBljFY2hhsXA"
        config.consumer_secret     = "24kKVPY9dl4GIzxXKbJAHMHF7V6L9qFPQl6PZDaIuk"
        config.access_token        = "85504015-m4EgoAJvD8TVoyiowicDdkAtnwijB76lYSMlkcZ2Q"
        config.access_token_secret = "nZkibax0opN2J1ZUOTUdDO6nfTTThEckwUExkBJkvVMuU"
      end
    end
end
