class Hall < ActiveRecord::Base
  include PaperclipUploadedFile

  HALL_TYPE = { exhibition: 'Exhibition',
                main: 'Main', 
                conference: 'Conference', 
                knowledge_lib: 'Knowledge Library',
                booth_list: 'Booth Listing'}
  
  resourcify
  has_ancestry

  belongs_to :venue
  belongs_to :template
  belongs_to :video
  belongs_to :background, class_name: 'Template'
  belongs_to :welcome_video_content, class_name: 'Content'

  has_many :videos
  has_many :webcasts
  has_many :booths
  has_many :literatures
  has_many :presentations

  has_and_belongs_to_many :sponsors
  has_and_belongs_to_many :contents

  validates :name, :hall_type, presence: true
  validates :venue, :template, associated: true, presence: true

  paperclip_file event_logo: UploadedFile::IMAGE_TYPE_HALL_EVENT_LOGO

  def location_name
    "#{venue.name if venue}: #{name}"
  end
  
  def exhibition_hall?
    hall_type == HALL_TYPE[:exhibition]
  end
  
  def main_hall?
    hall_type == HALL_TYPE[:main]
  end

  def conference_hall?
    hall_type == HALL_TYPE[:conference]
  end

  def knowledge_hall?
    hall_type == HALL_TYPE[:knowledge_lib]
  end

  def booth_list_hall?
    hall_type == HALL_TYPE[:booth_list]
  end
end
