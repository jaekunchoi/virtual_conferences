class SessionsController < Devise::SessionsController
  layout :layout_by_resource
  before_filter :set_host
  
  include ApplicationHelper

  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      if !session[:return_to].blank?
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        respond_with resource, :location => after_sign_in_path_for(resource)
      end
  end

  def set_host
    eventId = get_event_id()
    params[:id] = eventId unless eventId.nil?
    set_image params
  end

  def set_image params
    @event = Event.find_by_id(params[:id])
    if @event
      @event_image = @event.event_image.assets.url if @event.event_image
    end
  end

  def after_sign_in_path_for resource
    if current_user.has_role?(:visitor) && current_user.events.present?
      live_event = current_user.events.where("start <= ? AND finish >= ?", Date.today, Date.today).first
      if live_event.present?
        venue_venue_hall_visit_path(live_event.hall.venue, live_event.hall)
      else
        super
      end
    else
        super
    end
  end

end
