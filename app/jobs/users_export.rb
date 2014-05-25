class UsersExport
  include Resque::Plugins::Status

  def perform
    puts "Parsing CSV and exporting..."
    
    if options["event_id"].present?
      @users = User.joins(:events).where(:events_users => {:event_id => options["event_id"].to_i}).includes(:events)
    else
      @users = User.joins(:events).includes(:events)
    end
    
    prepared_user_list = map_user_resource_for_export @users
    generate_csv_report prepared_user_list

    puts "File export finished..."
  end

  def generate_csv_report users
    file_path = "#{Rails.public_path}/users-#{Time.now.strftime("%d-%m-%Y-%H%M%S")}.csv"
    CSV.open(file_path, "wb") do |csv|
      csv << %w{ id email title first_name last_name position work_phone company state industry mobile origin terms sign_in_count last_sign_in_at confirmed_at created_at events roles booths booth_closed_message }
      users.each do |user|
        csv << user
      end
    end
    puts file_path
    user = User.find(options["current_user_id"])
    csv_file = File.open(file_path)
    File.delete(csv_file) if user.update(:csv_file_attributes => { :assets => csv_file })
    # JobMailer.new.csv_export_complete(user).deliver
  end


  private

    def map_user_resource_for_export resource
      resource.map! { |u| [u.id, u.email, u.title, u.first_name, u.last_name, u.position, u.work_phone, u.company, u.state, u.industry, u.mobile, u.origin, 
        u.terms, u.sign_in_count, u.last_sign_in_at, u.confirmed_at, u.created_at, get_user_associations(u, "events"), get_user_associations(u, "roles"), 
        get_user_associations(u, "booths"), u.booth_closed_message] }
    end

    def get_user_associations resource, assoc_name
      begin
        if eval("resource.#{assoc_name}.present?")
          return eval("resource.#{assoc_name}.pluck(:name).join('; ')")
        else
          ''
        end
      rescue
        "Method or relation not found"
      end
    end

end