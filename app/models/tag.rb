class Tag < ActiveRecord::Base
  include PaperclipUploadedFile
  
  resourcify
	has_and_belongs_to_many :contents
  has_and_belongs_to_many :booths
  belongs_to :venue

  paperclip_file thumbnail_image: UploadedFile::IMAGE_TYPE_THUMBNAIL

  validates :venue, presence: true
end
