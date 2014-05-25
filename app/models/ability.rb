class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    
    if user.has_role? :admin
        can :manage, :all
    elsif user.has_role? :vendor
        can :manage, :all
    elsif user.has_role? :booth_rep
        can [:status, :update], User, :id => user.id
        can [:dashboard, :read], Venue
        can [:read, :show, :about, :about_ie, :leave_business_card, :products, :products_ie, 
          :literature, :literature_ie, :partners, :partners_ie, :presentations, 
          :presentations_ie, :contact, :contact_ie, :videos, :videos_ie, 
          :contact_info, :contact_info_ie, :chat_widget, :send_message, :send_business_card], Booth
        can [:edit, :update, :booth_rep], Booth, :user_id => user.id
        can :visit, Hall
        can :manage, :user_id => user.id
        can :manage, Product, :user_id => user.id
        can :manage, Content, :owner_user_id => user.id
        # can [:create, :upload, :save_video], Video
        can :all_events, Event
    elsif user.has_role? :host
        can :dashboard, Venue
        can :manage, Product, :user_id => user.id
        can :manage, Content, :owner_user_id => user.id
    elsif user.has_role? :visitor
        can :dashboard, Venue
        can :edit, User, :id => user.id
        can :visit, Hall
        can [:read, :show, :about, :about_ie, :leave_business_card, :products, :products_ie, 
          :literature, :literature_ie, :partners, :partners_ie, :presentations, :presentations_ie, 
          :contact, :contact_ie, :videos, :videos_ie, :contact_info, :contact_info_ie, :chat_widget, 
          :send_message, :send_business_card], Booth
        can :show, Event
        can :all_events, Event
        can :manage, Chat
        can [:view,:preview], Content
    end

  end
end
