class HallsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_venue, only: [:index, :new, :create]
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]
  before_action :set_hall, only: [:show, :edit, :update, :destroy, :exhibition, :conference, :visit]
  before_action :sidebar_menu
  before_action :sidebar_menu2, only: [:show, :edit, :update, :destroy, :exhibition, :conference, :visit]

  helper_method :get_knowledge_center_featured_content
  helper_method :get_hall_types
  
  # GET /halls
  def index
    @halls = Venue.find(params[:venue_id]).halls
  end

  # GET /halls/1
  def show
    redirect_to hall_path(@hall) if current_user.has_role? :visitor
  end

  # GET /halls/new
  def new
    @hall = Hall.new
    @hall.build_event_logo
    @hall.venue = @venue
    @url = venue_halls_path(@venue)
  end

  # GET /halls/1/edit
  def edit
    @hall.build_event_logo unless @hall.event_logo
    @url = hall_path(@hall)
    @venue.id = @hall.id unless @venue
  end

  # POST /halls
  def create
    @hall = Hall.new(hall_params)
    @url = venue_halls_path(@venue)
    if @hall.save
      redirect_to @hall, notice: 'Hall was successfully created.'
    else
      render action: 'new'
    end 
  end

  # PATCH/PUT /halls/1
  def update
    @url = hall_path(@hall)
    if @hall.update(hall_params)
      redirect_to @hall, notice: 'Hall was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /halls/1
  def destroy
    @hall.destroy
    redirect_to venue_halls_path(@venue), notice: 'Hall was successfully destroyed.'
  end

  def exhibition
    
  end

  def conference
    
  end

  def visit
    hide_sidebar 'hide-sidebar'
    if @hall.exhibition_hall? 
      @all_exhibition_halls = @hall.siblings.where(:hall_type => 'Exhibition')
      @exhibition_halls = @all_exhibition_halls.where("id NOT IN(?)", @hall.id).order(:name => :desc) 
      @prev_hall = @all_exhibition_halls.where("name < ?", @hall.name).order(:name => :desc).first
      @next_hall = @all_exhibition_halls.where("name > ?", @hall.name).order(:name => :asc).first
    elsif @hall.main_hall? 
      @conference_halls = @hall.children.where(:hall_type => 'Conference').where("id NOT IN(?)", @hall.id)
      @booth_ids = []
      @hall.children.where(:hall_type => 'Exhibition').each do |exhibition|
        @booth_ids << exhibition.booths.pluck(:id)
      end
      @products = Product.joins(:booths).where(:booths_products => { :booth_id => @booth_ids.flatten }).limit(5).order(:id => :desc)
    elsif @hall.knowledge_hall?
      @linked_content = @hall.contents.select {|content| content.valid_content?(:shallow)}
      @linked_content = Kaminari.paginate_array(@linked_content).page(params[:page]).per(6)
    end
    twitter
  end
  
  def get_knowledge_center_featured_content(maxNumberOfVideos)
    @hall.venue.knowledge_halls[0].contents.where("featured = 'true'")[0, maxNumberOfVideos]
  end

  def get_hall_types()
    return Hall::HALL_TYPE.values
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hall
      @hall = Hall.find(params[:id])
      uploaded_file_url(@hall)
    end

    def set_venue
      @venue = Venue.find(params[:venue_id])
    end

    # Only allow a trusted parameter "white list" through.
    def hall_params
      params.require(:hall).permit(:name, :template_id, :background_id, :colour, :greeting, 
        :greeting_type, :greeting_enable, :jumbotron, :jumbotron_enable, :venue_id, :hall_type,
        :parent_id, :welcome_video_content_id, { event_logo_attributes: [:assets] }, :sponsor_ids => [])
    end

    def uploaded_file_url(hall)
      @venue_background_url = hall.venue.top_background.assets.url if hall.venue.top_background if hall.venue
      if hall.venue.uploaded_file
        @event_logo = hall.venue.uploaded_file.assets.url
      else
        @event_logo = hall.event_logo.assets.url if hall.event_logo
      end
      @main_sponsor_logo = hall.venue.main_sponsor_logo.assets.url if hall.venue.main_sponsor_logo if hall.venue
    end

    def sidebar_menu2
      add_sidebar_menu ["Webcasts - settings", "play-circle-o"], "webcast-nav2", [[hall_webcasts_path(@hall), "List webcasts"], [new_hall_webcast_path(@hall), "Create a webcast"]], false
    end

    def twitter
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "irnj1j9xTlfBljFY2hhsXA"
        config.consumer_secret     = "24kKVPY9dl4GIzxXKbJAHMHF7V6L9qFPQl6PZDaIuk"
        config.access_token        = "85504015-m4EgoAJvD8TVoyiowicDdkAtnwijB76lYSMlkcZ2Q"
        config.access_token_secret = "nZkibax0opN2J1ZUOTUdDO6nfTTThEckwUExkBJkvVMuU"
      end
    end
end
