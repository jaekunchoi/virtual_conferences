class BoothsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_hall, only: [:index, :new, :create]
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]
  before_action :set_booth, only: [:show, :edit, :update, :destroy, :about, :leave_business_card, :products, :literature, :partners, :presentations, :contact, :videos, :booth_rep, :send_message, :send_business_card]
  before_action :sidebar_menu, :set_template, :set_videos, :set_literatures, :set_presentations, :role_vars, :set_slideshare_api
  
  helper_method :get_ticker_message_arr
  helper_method :view_type
  helper_method :get_resources
  helper_method :new_path, :index_path

  layout "users"
  
  include ApplicationHelper
  include AuthHelper

  def new_path
    @hall.present? ? new_hall_booth_path(@hall) : new_venue_booth_path(@venue)
  end
  
  def index_path
    @hall.present? ? hall_booths_path(@hall) : venue_booths_path(@venue)
  end
  

  def index
    if(current_user.has_role?(:admin) || current_user.has_role?(:vendor))
      if (@hall.present?)
        @booths = @hall.booths
      else 
        @booths = []
        @venue.halls.each { |hall| hall.booths.each {|booth| @booths << booth}}
      end
    else
      @booths = Booth.where(:user_id => current_user.id)
    end
  end

  def show
    @chats = Chat.where(:chattable_type => 'Booth', :chattable_id => @booth.id)
    booth_visits
    @client = twitter
    hide_sidebar 'hide-sidebar'
    @venue = @booth.hall.venue
    @slideshare = slideshare
    add_sidebar_menu ["Directory", "home"], "home-nav", 
      [[venue_venue_hall_visit_path(@booth.hall.venue, @booth.hall), "Visit hall"]], false
    @visualContent = filter_contents(@booth.contents, [Content::CONTENT_TYPE[:youtube_video], Content::CONTENT_TYPE[:slideshare]])
  end

  def new
    @booth = Booth.new
    build_resources @booth
    @url = index_path
  end

  def edit
    build_resources @booth
    @url = booth_path(@booth)
  end

  def create
    @booth = Booth.new(booth_params)
    build_resources @booth
    @url = hall_booths_path(@booth.hall)
    respond_to do |format|
      if @booth.save
      format.html { redirect_to @booth, notice: 'Booth was successfully created.' }
      format.json { render action: 'show', status: :created, location: @booth }
      else
      format.html { render action: 'new' }
      format.json { render json: @booth.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    puts @booth.thumbnail_image
    respond_to do |format|
      if @booth.update(booth_params)
        sync_update @booth if params['booth']['chat'].present?
        format.html { redirect_to @booth, notice: 'Booth was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @booth.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @hall = @booth.hall
    @booth.destroy
    respond_to do |format|
      format.html { redirect_to hall_booths_path(@hall) }
      format.json { head :no_content }
    end
  end

  %w(about leave_business_card products partners literature presentations contact videos contact_info).each do |method_name|
    define_method(method_name) { render layout: false }
    define_method(method_name + '_ie') { render layout: false }
  end
  
  def get_resources()
    @resources ||= filter_contents(@booth.contents, [Content::CONTENT_TYPE[:resource]])
    return @resources
  end
  
  def chat_widget
    
  end

  def booth_rep
    
  end

  def send_message
    user = User.find(params[:user][:id])
    UserMailer.send_message_booth(get_event(), user, params[:user][:message], @booth).deliver
  end
  
  def send_business_card
    user = User.find(params[:user][:id])
    UserMailer.send_business_card(get_event(), user, params[:user][:message], @booth).deliver
  end

  def get_ticker_message_arr()
    
    #get rid of any divs and change them to line breaks (this is how the control represents line breaks)
    tickerMessage = @booth.ticker_message.gsub(/<div.*?>/,"<br>").gsub("</div>","")
    
    tickerMessage = tickerMessage.gsub(/<a/,"<a target='_blank' ") #force link targets to a new tab
    
    tickerMessageArr = tickerMessage.split(/<br.*?>/)
    
    forceLineBreaksOnHtml(tickerMessageArr, 75)
    
  end
  
  def view_type
    if @view_type_obj.nil?
      if @booth.nil?
        @view_type_obj = get_view_type()
      else
        @view_type_obj = get_view_type_booth(@booth)
      end
    end
    @view_type_obj
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_booth
      @booth = Booth.find(params[:id])
      uploaded_file_url(@booth)
      @venue = @booth.hall.venue
      @hall = @booth.hall
    end

    def set_hall
      @hall = Hall.find(params[:hall_id]) if params[:hall_id]
      @venue = nil
      @venue = Venue.find(params[:venue_id]) if params[:venue_id]
      @venue ||= @hall.venue if @hall
    end

    def set_template
      @templates = Template.where(:template_type => "Booth")
    end

    def set_videos
      if current_user.has_role? :admin
        @videos = Video.all
      else
        @videos = Video.where("user_id = ? OR id in (SELECT video_id FROM booths_videos WHERE booth_id = ?)", current_user.id, @booth.id)
      end
    end

    def set_literatures
      if current_user.has_role? :admin
        @literatures = Literature.all
      else
        @literatures = Literature.where("user_id = ? OR id in (SELECT literature_id FROM booths_literatures WHERE booth_id = ?)", current_user.id, @booth.id)
      end
    end

    def set_presentations
      if current_user.has_role? :admin
        @presentations = Presentation.all
      else
        @presentations = Presentation.where("user_id = ? OR id in (SELECT presentation_id FROM booths_presentations WHERE booth_id = ?)", current_user.id, @booth.id)
      end
    end

    def build_resources booth
      booth.build_television_ad unless booth.television_ad
      booth.build_company_logo unless booth.company_logo
      booth.build_booth_main_image unless booth.booth_main_image
      booth.build_thumbnail_image unless booth.thumbnail_image
    end

    def set_yt_session
      @yt_session ||= Video.yt_session
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booth_params
      params.require(:booth).permit(:name, :company_website, :social_media, :contact_info, :email, :about_us, :button1_label, :button1_content, 
        :greeting_type, :event_id, :public_chat, :twitter_roll, :twitter_hash_tag, :survey_url, :prize_giveaway_description, 
        :newsletter_description, :ticker_message, :greeting_image_id, :greeting_audio_id, :greeting_video_id, :greeting_virtual_id, 
        :user_id, :booth_package, :display_mode, :greeting_video, :facebook_url, :linkedin_url, :twitter_url, 
        :top_message, :template_id, :hall_id, :greeting_video_enabled, :video_ids => [], :tag_ids => [], :literature_ids => [], :presentation_ids => [],
        company_logo_attributes: [:assets], booth_main_image_attributes: [:assets], television_ad_attributes: [:assets], thumbnail_image_attributes: [:assets])
    end

    def uploaded_file_url(booth)
      @television_ad = booth.television_ad.assets.url if booth.television_ad
      @company_logo_url = booth.company_logo.assets.url if booth.company_logo
      @booth_main_image = booth.booth_main_image.assets.url if booth.booth_main_image
    end

    def booth_visits
      visits = cookies[:booth_visits].to_i
      visits = visits + 1 unless visits.blank?
    end

    def twitter
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "BgxZnm3JZhMtMwCuwUxA"
        config.consumer_secret     = "vsJf0GPwhpJBk4BzXcV5zA6MGcGIeFQyOmpNRXVJEn4"
        config.access_token        = "883262408-juZqQsvW5RnT2xNwLGBvFJmerAvjq28uJj2SVoyk"
        config.access_token_secret = "zq32CyvIRavvf1uhhXhy5ev4iBqT0oeUyfswADeAUM"
      end
    end

    def set_slideshare_api
      @slideshare_base_uri = "www.slideshare.net/api/2"
      @slideshare_username = "jaechoi83"
      @slideshare_password = "1qaz2wsx"
      @slideshare_api_key = "XB3pS8Bm"
      @slideshare_secret = "81LqkNkv"
    end

    def slideshare
      Slip::Slideshare::Client.new(@slideshare_api_key, @slideshare_secret)
    end

    def role_vars
      if current_user.has_role? :booth_rep
        hide_sidebar 'hide-sidebar'
      end
    end
end
