class User < ActiveRecord::Base
  include PaperclipUploadedFile
  
  LOCATIONS = {VIC: "Victoria", 
              NSW: "New South Wales", 
              ACT: "Australian Capital Territory", 
              QLD: "Queensland", 
              WA: "Western Australia", 
              SA: "South Australia", 
              TAS: "Tasmania", 
              NT: "Northern Territory",
              NZ: "New Zealand",
              INTL: "International"}
  
  # resourcify

  after_create :assign_default_role
  rolify :before_add => :before_add_method
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, :lastseenable, :invitable
  devise :timeoutable, :timeout_in => 2.weeks

  has_and_belongs_to_many :events, :autosave => true

  has_many :venues
  has_many :booths
  has_many :webcasts
  # has_many :events, through: :venues
  has_many :from_user_chats, :foreign_key => 'from_user_id', :class_name => 'Chat'
  has_many :to_user_chats, :foreign_key => 'to_user_id', :class_name => 'Chat'
  
  paperclip_file uploaded_file: nil,
                 csv_file: UploadedFile::RESOURCE_FILE_CSV

  validates :first_name, :last_name, presence: true
  validates :terms, :presence => true, :on => :create
  
  before_save do
    self.email = email.downcase if email
  end
 
  def name
    "#{first_name} #{last_name}"
  end
  
  def name_and_email
    "#{first_name} #{last_name} - #{email}"
  end
  
  def state_name
    LOCATIONS[state.to_sym] if state.present?
  end

  def avatar_url
    uploaded_file.assets.url if uploaded_file
  end
  
  def before_add_method(role)
  	# do something
  end

  def assign_default_role
    add_role :visitor
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w{ id email title first_name last_name position work_phone company state industry mobile origin terms sign_in_count last_sign_in_at confirmed_at created_at events roles booths booths_closed_message }
      all.each do |user|
        events = ''
        roles = ''
        booths = ''
        row = []
        events = user.events.first.name.to_s if user.events.present?
        roles = user.roles.first.name.to_s if user.roles.present?
        booths = user.booths.first.name.to_s if user.booths.present?
        row << user.attributes.values_at("id", "email", "title", "first_name", "last_name", "position", "work_phone", "company", "state", "industry", "mobile", "origin", "terms", "sign_in_count", "last_sign_in_at", "confirmed_at", "created_at", "booths_closed_message")
        row << [events]
        row << [roles]
        row << [booths]
        csv << row.flatten
      end
    end
  end

end
