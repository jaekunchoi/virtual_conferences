class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Menu

  layout :layout_by_resource
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :images, :hide_sidebar, :global_vars, :set_mailer_host
  before_action :sidebar_menu, :role_variables
  
  ICONS= {
            venue: "map-marker",
            event: "calendar",
            hall: "cubes",
            booth: "cube",
            template: "paw",
            content: "file-photo-o",
            product: "trophy",
            user: "users",
            dashboard: "dashboard",
            tag: "tags"
  }

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :title, :state, :position, :work_phone, :company, :industry, {interested_topic: []}, :event_ids, :mobile, :origin, :terms]
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email) }
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation, :current_password,
        :title, :first_name, :last_name, :position, :work_phone, :mobile, :company, :state, :industry,
        :uploaded_file, :origin, :terms, { uploaded_file_attributes: [:assets]} )
    end
    # Only add some parameters
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name]
    # Override accepted parameters
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:first_name, :last_name, :password, :password_confirmation,
               :invitation_token)
    end
  end

  def layout_by_resource
    if user_signed_in?
      "users"
    else
      "application"
    end
  end

  def images
    @image_url = current_user.uploaded_file.assets.url if current_user.uploaded_file if user_signed_in?
  end

  def global_vars
  end

  def sidebar_menu(top_level=nil, menu_class=nil, menu_items=nil, expanded=nil)
    @sidebar_menu_item ||= []
    
    @venue = @hall.venue if @hall.venue if @hall
    @hall = @booth.hall if @booth.hall if @booth
    
    menuItems = []
    
    
    path = request.fullpath
    if user_signed_in?
      if current_user.has_role? :admin
        @hide_sidebar = 'hide-sidebar' if current_user.has_role? :visitor if user_signed_in?
        menuItems = [:venue, :venue_create, :event, :hall, :booth, :template, :content, :product, :user, :user_create, :tag]
      elsif current_user.has_role? :vendor
        menuItems = [:venue, :booth, :template, :content, :product]
      elsif current_user.has_role? :booth_rep
        menuItems = [:venue, :booth, :template, :content, :product]
      elsif current_user.has_role? :host
        menuItems = [:venue, :content, :product]
      elsif current_user.has_role? :visitor
        menuItems = [:venue, :user]
      else
        menuItems = [:venue]
      end
    end
    
    menuItems.each do |menuItem|
      case menuItem
        when :venue
          items = [[venues_dashboard_path, "Dashboard"]]
          if menuItems.include?(:venue_create)
            items << [new_venue_path, "Create a venue"]
          end
          add_sidebar_menu(["Venues", ICONS[:venue]], "venue-nav", items, request.fullpath.starts_with?(venues_path()))
        when :event
          if @venue
            add_sidebar_menu ["Events", ICONS[:event]], "event-nav", [[venue_events_path(@venue), "List events"],[new_venue_event_path(@venue), "Create a event"]], path.starts_with?(venue_events_path(@venue)) unless params[:controller] == 'content'
          end 
        when :hall
         if @venue
          add_sidebar_menu ["Halls", ICONS[:hall]], "hall-nav", [[venue_halls_path(@venue), "List halls"], [new_venue_hall_path(@venue), "Create a hall"]], path.starts_with?(venue_halls_path(@venue)) unless params[:controller] == 'content'
         end
        when :booth
          if @venue
            add_sidebar_menu ["Booths", ICONS[:booth]], "booth-nav", [[venue_booths_path(@venue), "List booths"],[new_venue_booth_path(@venue), "Create a booth"]], path.starts_with?(venue_booths_path(@venue)) unless params[:controller] == 'content'
          elsif @hall
            add_sidebar_menu ["Booths", ICONS[:booth]], "booth-nav", [[hall_booths_path(@hall), "List booths"],[new_hall_booth_path(@hall), "Create a booth"]], path.starts_with?(hall_booths_path(@hall)) unless params[:controller] == 'content'
          end
        when :template
          add_sidebar_menu ["Templates", ICONS[:template]], "templates-nav", [[templates_path(@venue), "List templates"], [new_template_path(@venue), "Create a template"]], false unless params[:controller] == 'templates'
        when :content
          if @venue
            add_sidebar_menu ["Content", ICONS[:content]], "content-nav", [[venue_contents_path(@venue), "List contents"], [new_venue_content_path(@venue), "Create content"]], path.starts_with?(contents_path()) unless params[:controller] == 'content'
          end
        when :tag
          if @venue
            add_sidebar_menu ["Tag", ICONS[:tag]], "tag-nav", [[venue_tags_path(@venue), "List tags"], [new_venue_tag_path(@venue), "Create tag"]], path.starts_with?(venue_tags_path(@venue)) unless params[:controller] == 'content'
          end
        when :product
          add_sidebar_menu ["Products", ICONS[:product]], "product-nav", [[products_path(@venue), "List products"], [new_product_path(@venue), "Create a product"]], false unless params[:controller] == 'products'
        when :user
          items = [[users_path, "List users"]]
          if menuItems.include?(:user_create)
            items << [new_user_path, "Create a user"] << [new_user_invitation_path, "Invite user"] << [import_users_path, "Import users"]
          end
          add_sidebar_menu ["Users", ICONS[:user]], "user-nav", items, false unless params[:controller] == 'users'
      end
    end
  end

  def role_variables
    if user_signed_in?
      if current_user.has_role? :admin
      elsif current_user.has_role? :booth_rep
        @booth = current_user.booths.first
        @unread_chats = current_user.booths.first.chats.where(:read => [false, nil]).order(:created => :desc).size if current_user.booths.present?
      end
    end
  end

  def add_sidebar_menu(top_level, menu_class, menu_items, expanded)
    @sidebar_menu_item << [top_level, menu_class, menu_items, expanded]
  end

  def hide_sidebar value = nil
    @hide_sidebar = value
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
end
