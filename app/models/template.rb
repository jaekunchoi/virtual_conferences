class Template < ActiveRecord::Base
  include PaperclipUploadedFile
  
  TEMPLATE_TYPE = { booth: "Booth", 
                    webcast: "Webcast", 
                    mainHall: "Main Hall", 
                    conferenceHall: "Conference Hall", 
                    exhibitionHall: "Exhibition Hall"}
  TEMPLATE_SUB_TYPE = { boothHall: "Booth - Hall Format",
                        knowledge_knowledgeLibrary: "Booth - Hall Format"}
  
  resourcify
  
  paperclip_file uploaded_file: UploadedFile::IMAGE_TYPE_TEMPLATE,
                 thumbnail_image: UploadedFile::IMAGE_TYPE_TEMPLATE_THUMBNAIL

  scope :booth, -> { where(template_type: :booth) }

  validates :name, presence: true, uniqueness: true
  validates :uploaded_file, :template_type, presence: true

  def templateSubTypes
    TEMPLATE_SUB_TYPE
  end
end
