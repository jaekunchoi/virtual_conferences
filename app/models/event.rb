class Event < ActiveRecord::Base
  include PaperclipUploadedFile
  
  resourcify
  belongs_to :venue
  belongs_to :hall

  validates :name, :start, :finish, presence: true
  validates :hall, associated: true, presence: true
  validates :event_url, :url => true, :allow_blank => true

  has_and_belongs_to_many :users

  paperclip_file event_image: UploadedFile::IMAGE_TYPE_EVENT_IMAGE,
                 logo1: UploadedFile::IMAGE_TYPE_EVENT_LOGO1,
                 logo2: UploadedFile::IMAGE_TYPE_EVENT_LOGO2,
                 top_bar_background: UploadedFile::IMAGE_TYPE_TOP_BAR_BACKGROUND

 #  def status
 #    if (Time.now >= finish.to_datetime)
  #   "On demand"
  # elsif (Time.now >= start.to_datetime)
  #   "Live"
  # end
 #  end

 def find_by_id(id)
   find(id)
 end

end
