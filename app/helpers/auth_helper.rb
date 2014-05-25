module AuthHelper
  include ActionView::Helpers::AssetTagHelper

  def get_view_type_booth(booth)
    view_type = []
    if user_signed_in?
      if current_user.has_role? :admin
        view_type.push :admin
        view_type.push :booth_rep
        view_type.push :visitor
      elsif current_user.has_role? :booth_rep and current_user.booths.exists?(booth.id)
        view_type.push :booth_rep
        view_type.push :visitor
      elsif current_user.has_role? :visitor
        view_type.push :visitor
      end
    end
    view_type
  end

  def get_view_type_user(user)
    view_type = []
    if user_signed_in?
      if current_user.has_role? :admin
        view_type.push :admin
        view_type.push :self
        view_type.push :booth_rep
        view_type.push :other
      elsif current_user == user
        view_type.push :self
        view_type.push :booth_rep
        view_type.push :other
      elsif current_user.has_role? :booth_rep
        view_type.push :booth_rep
        view_type.push :other
      else
        view_type.push :other
      end
    end
    view_type
  end
  
  def get_view_type()
    view_type = []
    if user_signed_in?
      if current_user.has_role? :admin
        view_type.push :admin
        view_type.push :booth_rep
        view_type.push :other
      elsif current_user.has_role? :booth_rep
        view_type.push :booth_rep
        view_type.push :other
      else
        view_type.push :other
      end
    end
    view_type
  end
end