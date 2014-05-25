class WebcastsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]
  before_action :set_webcast, only: [:show, :edit, :update, :destroy, :update_widget_locations]
  before_action :set_hall, :set_venue, only: [:show, :edit, :update, :destroy]
  before_action :set_youtube, :set_hangout, :set_presentation, only: [:new, :edit, :create, :update]
  before_action :set_area_vars, only: [:show, :new, :edit, :create, :update]
  before_action :sidebar_menu

  # GET /webcasts
  def index
    if(current_user.has_role?(:admin) || current_user.has_role?(:vendor))
      @webcasts = Webcast.all
    else
      @webcasts = Webcast.where(:user_id => current_user.id)
    end
  end

  # GET /webcasts/1
  def show
    current_user.update(:booth_closed_message => @webcast.id)
    @visitor_view = true
    hide_sidebar 'hide-sidebar'
    
    if @slideshare.present?
      if @slideshare.seconds
        @calculated_seconds = []
        slideshare_seconds = @slideshare.seconds.split(',')
        slideshare_seconds.each_with_index do |seconds, index|
          @calculated_seconds << seconds.split('.')[0].to_i*60 + seconds.split('.')[1].to_i
        end
        # first, *middle, last = [0], *@calculated_seconds
        # @calculated_seconds = first + middle.flat_map{|x|[x,x]} << last
        @second_video = Video.find(32)
        @video_code = '', counter = 1
        @calculated_seconds.each_with_index do |data, i|
          next if i.odd?
          @video_code << "video.code({
            start: #{@calculated_seconds[i]},
            end: #{@calculated_seconds[i+1] ? @calculated_seconds[i+1] : 0},
            onStart: function() {
              flashMovie = document.getElementById('slideshare-player');
              flashMovie.jumpTo(#{counter += 1});
            },
            onEnd: function() {
              flashMovie = document.getElementById('slideshare-player');
              flashMovie.jumpTo(#{counter += 1});
            }
          });"
        end
        @video_code = @video_code.drop(2).join(' ')
        if(@webcast.start.to_i..@webcast.finish.to_i).cover?(Time.now.to_i)
          @youtube_start_seconds = Time.now.to_i - @webcast.start.to_i
        else 
          @youtube_start_seconds = 0
        end
      end
    end
  end

  # GET /webcasts/new
  def new
    @webcast = Webcast.new
    @hall = Hall.find(params[:hall_id])
    @url = hall_webcasts_path(@hall)
  end

  # GET /webcasts/1/edit
  def edit
    @url = webcast_path(@webcast)
  end

  # POST /webcasts
  def create
    @webcast = Webcast.new(webcast_params)

    if @webcast.save
      redirect_to @webcast, notice: 'Webcast was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /webcasts/1
  def update
    if @webcast.update(webcast_params)
      redirect_to @webcast, notice: 'Webcast was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /webcasts/1
  def destroy
    @hall = @webcast.hall
    @webcast.destroy
    respond_to do |format|
      format.html { redirect_to hall_webcasts_path(@hall), notice: 'Webcast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def visit
    
  end

  def update_widget_locations
    # @webcast.update(:widget_locations => {:left_area1 => {""}} )
    # @webcast.update(:widget_locations =>)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_webcast
      @webcast = Webcast.find(params[:id])
    end

    def set_hall
      @hall = @webcast.hall
    end

    def set_venue
      @venue = @webcast.hall.venue if @webcast.hall
    end

    def set_youtube
      if current_user.has_role? :admin
        @youtube = Video.find(:all, :conditions => ["hangouts = ?", false])
      else
        @youtube = Video.find(current_user.id, :conditions => ["hangouts = ?", false])
      end
      @youtube = @youtube.to_a.each_with_object({}){ |c,h| h[c.name] = "#{c.yt_youtube_id}:#{c.id}" }
    end

    def set_hangout
      if current_user.has_role? :admin
        @hangouts = Video.find(:all, :conditions => ["hangouts = ?", true])
      else
        @hangouts = Video.find(current_user.id, :conditions => ["hangouts = ?", true])
      end
      @hangouts = @hangouts.to_a.each_with_object({}){ |c,h| h[c.name] = "#{c.yt_youtube_id}:#{c.id}" }
    end

    def set_presentation
      if current_user.has_role? :admin
        @presentation = Presentation.all
      else
        @presentation = Presentation.find(current_user.id)
      end
      @presentation = @presentation.to_a.each_with_object({}){ |c,h| h[c.name] = "#{c.doc}:#{c.id}" }
    end

    # Only allow a trusted parameter "white list" through.
    def webcast_params
      params[:presentation] = params[:presentation].split(':')[0] if params[:presentation]
      params.require(:webcast).permit(:name, :hall_id, :webcast_type, :media_type, 
        :user_id, :details, :template_id, :background_colour, :start, :finish, 
        :leftarea1, :midarea1, :leftarea2, :midarea2, :rightarea2)
    end

    def sidebar_menu
      @hall = @webcast.hall if @webcast.hall if @webcast
      super ["Webcasts - settings", "play-circle-o"], "webcast-nav2", [[hall_webcasts_path(@hall), "List webcasts"], [new_hall_webcast_path(@hall), "Create a webcast"]], true
    end

    def sidebar_menu2
      add_sidebar_menu ["Presentations", "beer"], "presentation-nav", [[presentations_path, "List presentations"], [new_presentation_path, "Create a presentation"]], false
      add_sidebar_menu ["Videos", "video-camera"], "video-nav", [[videos_path, "List videos"], [new_video_path, "Create a video"]], false
    end

    def hstore_string_to_hash string
      data = %Q|#{string}|.gsub('\\', '').gsub(/{+/, '[').gsub(/}/, ']').scan(/(\w+)/)
      Hash[data.first.first, data.slice(1..-1).flatten] if data.first
      # x = Hash[data.first.first, data.slice(1..-1).flatten]
      # Hash[data.first.first, Hash[*x[data.first.first]]]
    end

    def webcast_area_convert_resources area
      if area.first.first == 'youtube'
        @youtube_video = Video.find_by_id(area[area.first.first][0].to_i)
      elsif area.first.first == 'hangouts'
        @hangout_video = Video.find_by_id(area[area.first.first][0].to_i)
      elsif area.first.first == 'presentation'
        @slideshare = Presentation.find_by_id(area[area.first.first][0].to_i)
      end
    end

    def set_area_vars
      @leftarea1 = hstore_string_to_hash(@webcast.leftarea1) if @webcast.leftarea1.present?
      @midarea1 = hstore_string_to_hash(@webcast.midarea1) if @webcast.midarea1.present?
      @leftarea2 = hstore_string_to_hash(@webcast.leftarea2) if @webcast.leftarea2.present?
      @midarea2 = hstore_string_to_hash(@webcast.midarea2) if @webcast.midarea2.present?
      @rightarea2 = hstore_string_to_hash(@webcast.rightarea2) if @webcast.rightarea2.present?

      @resource1 = webcast_area_convert_resources(@leftarea1) if @leftarea1
      @resource2 = webcast_area_convert_resources(@midarea1) if @midarea1
      @resource3 = webcast_area_convert_resources(@leftarea2) if @leftarea2
      @resource4 = webcast_area_convert_resources(@midarea2) if @midarea2
      @resource5 = webcast_area_convert_resources(@rightarea2) if @rightarea2
    end
end
