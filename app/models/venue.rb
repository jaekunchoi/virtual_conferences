class Venue < ActiveRecord::Base
  include PaperclipUploadedFile
  
  resourcify
  belongs_to :user
  belongs_to :event_redirect, :class_name => 'Event'
  has_many :events, dependent: :destroy
  has_many :halls, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :contents, dependent: :destroy

  validates :name, :user, presence: true
  
  paperclip_file uploaded_file: UploadedFile::IMAGE_TYPE_VENUE_LOGO,
                 top_background: UploadedFile::IMAGE_TYPE_TOP_BACKGROUND,
                 background_image: UploadedFile::IMAGE_TYPE_VENUE_BACKGROUND_IMAGE,
                 main_sponsor_logo: UploadedFile::IMAGE_TYPE_VENUE_MAIN_SPONSOR
  

  after_create :create_default_halls

  def create_default_halls
    
  end
  
  def exhibition_halls
    halls.select{|hall| hall.exhibition_hall?}
  end

  def knowledge_halls
    halls.select{|hall| hall.knowledge_hall?}
  end

  def main_halls
    halls.select{|hall| hall.main_hall?}
  end

  def booth_list_halls
    halls.select{|hall| hall.booth_list_hall?}
  end
end
