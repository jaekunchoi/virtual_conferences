class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:all_events_public]
  before_filter :set_venue, only: [:index, :new, :create]
  load_and_authorize_resource :except => [:show, :all_events_public]
  skip_load_resource :only => [:create]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :display_event]
  before_action :sidebar_menu

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    respond_to do |format|
      format.html { @events }
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    if current_user.has_role? :visitor
        redirect_to venue_venue_hall_visit_path(@event.venue, @event.hall)
    end
  end

  def visit
    redirect_to venue_venue_hall_visit_path(@event.venue, @event.hall)
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.build_logo1
    @event.build_logo2
    @event.build_event_image
    @event.build_top_bar_background
    @url = venue_events_path(@venue)
  end

  # GET /events/1/edit
  def edit
    @event.build_logo1 unless @event.logo1
    @event.build_logo2 unless @event.logo2
    @event.build_event_image unless @event.event_image
    @event.build_top_bar_background unless @event.top_bar_background
    @url = event_path(@event)
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @url = venue_events_path(@venue)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @venue = @event.venue
    @event.destroy
    respond_to do |format|
      format.html { redirect_to venue_events_path(@venue) }
      format.json { head :no_content }
    end
  end

  def display_event
  end


  def all_events
    if current_user.has_role?(:visitor)
      events = current_user.events
    elsif current_user.has_role?(:booth_rep)
      events = current_user.events
    else
      events = Event.joins(:venue).where(:venues => {:user_id => current_user.id})
    end
    render json: events
  end

  def all_events_public
    events = Event.all
    render json: events
  end

  def event_registration_page
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
      uploaded_file_url(@event)
    end

    def set_venue
      @venue = Venue.find(params[:venue_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :status, :start, :finish, :event_url, 
        :event_reports_url, :hall_id, :logo1, :logo2, :top_bar_background, 
        :colour, :publish_event, :event_image, :description, :search_keywords,
        :closed_event_redirect, :comments, :venue_id, { event_image_attributes: [:assets]}, 
        { logo1_attributes: [:assets]}, { logo2_attributes: [:assets]}, { top_bar_background_attributes: [:assets]} )
    end

    def uploaded_file_url(event)
      @event_image = event.event_image.assets.url if event.event_image
      @event_logo1 = event.logo1.assets.url if event.logo1
      @event_logo2 = event.logo2.assets.url if event.logo2
      @top_bar_background = event.top_bar_background.assets.url if event.top_bar_background
    end
end
