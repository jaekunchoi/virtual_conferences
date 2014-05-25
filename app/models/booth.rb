class Booth < ActiveRecord::Base
  include PaperclipUploadedFile
  resourcify

	belongs_to :user
	belongs_to :event
	belongs_to :template
  	belongs_to :hall
	has_and_belongs_to_many :tags
	has_and_belongs_to_many :partners
	has_and_belongs_to_many :forums
	has_and_belongs_to_many :products
	has_and_belongs_to_many :literatures
	has_and_belongs_to_many :presentations
	has_and_belongs_to_many :videos
  has_and_belongs_to_many :contents
	has_many :sponsored_videos, class_name: "Video", foreign_key: "sponsor_id"

  paperclip_file television_ad: UploadedFile::IMAGE_TYPE_TV, 
                 company_logo: UploadedFile::IMAGE_TYPE_COMPANY, 
                 booth_main_image: UploadedFile::IMAGE_TYPE_BOOTH,
                 thumbnail_image: UploadedFile::IMAGE_TYPE_THUMBNAIL

	has_many :chats, as: :chattable, dependent: :destroy
	accepts_nested_attributes_for :chats

	validates :name, :user, :booth_package, :event, :presence => { :message => "Cannot be blank" }
	validates :template, associated: true, presence: true
	validates :hall, associated: true, presence: true
	# validates_length_of :display_mode, :minimum => 0, :allow_nil => false, :message => "Please select display mode"

	def location_name
    "#{hall.venue.name if hall and hall.venue}: #{name}"
  end

end
