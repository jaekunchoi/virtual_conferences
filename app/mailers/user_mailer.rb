class UserMailer < ActionMailer::Base
  default from: Rails.configuration.virtual_conferences.admin_email
  include ApplicationHelper
  @unsubscribeable = true;
  
  def send_message_booth(event, user, message, booth)
    _send_booth_email(event, user, message, booth)
  end

  def send_business_card(event, user, message, booth)
    _send_booth_email(event, user, message, booth)
  end
  
  private
    def _send_booth_email(event, user, message, booth)
      @user = user
      @message = message
      @unsubscribeable = false;
      if event.nil? || !event.event_url.present?
        fromAddress = Rails.configuration.virtual_conferences.company_url
      else
        fromAddress = Addressable::URI.parse(event.event_url).host
      end
      
      @eventName = event.nil? ? Rails.configuration.virtual_conferences.default_site_name : event.name
      @event_url = event.nil? ? "" : event.event_url
      
      mail( to: get_booth_email(booth),
            bcc: Rails.configuration.virtual_conferences.admin_email,
            from: '"'+Rails.configuration.virtual_conferences.events_team_name+'('+@eventName.gsub(/"/,"")+')" <noreply@'+fromAddress+'>',
            subject: "Important "+@eventName+": new customer message"
           )
    end
end
