class UsersDatatable
  delegate :params, :l, :link_to, :number_to_currency, to: :@view
  include Rails.application.routes.url_helpers

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.total_count,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      [
        "#{link_to 'Show', user} | #{link_to 'Edit', edit_user_path(user)} | #{link_to 'Destroy', user, :method => :delete, :data => { :confirm => 'Are you sure?' }}",
        assoc_to_s(user.roles),
        assoc_to_s(user.events),
        user.email,
        assoc_to_s(user.booths),
        user.first_name,
        user.last_name,
        user.position,
        user.work_phone,
        user.company,
        user.sign_in_count,
        date_format(user.current_sign_in_at),
        date_format(user.confirmed_at),
        date_format(user.created_at)
        
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.
      # joins(:roles).
      joins("LEFT JOIN events_users ON events_users.user_id = users.id LEFT JOIN events ON events.id = events_users.event_id").
      # joins("LEFT JOIN booths ON booths.user_id = users.id").
      group("users.id").
      order("#{sort_column} #{sort_direction}")
      # select("distinct(users.id, roles.name), users.*")
    users = users.page(page).per(per_page)
    if params[:sSearch].present?
      users = users.where("events.name like :search OR users.email like :search OR users.first_name like :search OR users.last_name like :search OR users.company like :search", 
        search: "%#{params[:sSearch]}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id roles.name events.name email booths.name first_name last_name position work_phone company sign_in_count current_sign_in_at confirmed_at created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def assoc_to_s assoc_object
    assoc_object.map{ |data| data.name }.join ', '
  end

  def date_format date, format = :default
    begin
      l date, format: format
    rescue
      nil
    end
  end
end