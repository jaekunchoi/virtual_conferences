class UploadedFile < ActiveRecord::Base
  IMAGE_TYPE_STANDARD = 'Standard'
  IMAGE_TYPE_TV = 'television_ad'
  IMAGE_TYPE_COMPANY = 'company_logo'
  IMAGE_TYPE_BOOTH = 'booth_main_image'
  IMAGE_TYPE_THUMBNAIL = 'thumbnail'
  IMAGE_TYPE_TOP_BACKGROUND = 'top_background'
  IMAGE_TYPE_VENUE_LOGO = 'venue_logo'
  IMAGE_TYPE_EVENT_IMAGE = 'event_image'
  IMAGE_TYPE_EVENT_LOGO1 = 'event_logo1'
  IMAGE_TYPE_EVENT_LOGO2 = 'event_logo2'
  IMAGE_TYPE_VENUE_BACKGROUND_IMAGE = 'venue_background_image'
  IMAGE_TYPE_VENUE_MAIN_SPONSOR = 'venue_main_sponsor'
  IMAGE_TYPE_PRESENTATION_LOGO = 'presentation_logo'
  IMAGE_TYPE_TOP_BAR_BACKGROUND = 'top_bar_background'
  IMAGE_TYPE_TEMPLATE = 'template'
  IMAGE_TYPE_TEMPLATE_THUMBNAIL = 'template_thumbnail'
  IMAGE_TYPE_HALL_EVENT_LOGO = 'hall_event_logo'

  RESOURCE_FILE = 'resource_file'
  RESOURCE_FILE_CSV = 'csv'

  HOLDING_IMAGE_START = 'holding_image_start'
  HOLDING_IMAGE_FINISH = 'holding_image_finish'
  HOLDING_IMAGE_QNA = 'holding_image_qna'

  belongs_to :imageable, polymorphic: true

  has_attached_file :assets
  after_post_process :save_image_dimensions, if: Proc.new { |uploaded_file| uploaded_file.assets.content_type =~ /png|gif|jpeg/ }

  validates_attachment_content_type :assets, 
    content_type: [/^image\/(png|gif|jpeg)/, "text/csv"],
    default_url: nil,
    message: "only (png|gif|jpeg) images are allowed and the size cannot exceed 5mb",
    size: { :in => 0..5000.kilobytes }, 
    if: Proc.new { |uploaded_file| uploaded_file.image_type != RESOURCE_FILE }

  validates_attachment_content_type :assets, 
    content_type: /^application\/(vnd.ms-powerpoint|vnd.openxmlformats-officedocument.presentationml.presentation|vnd.openxmlformats-officedocument.wordprocessingml.document|pdf)/,
    default_url: nil,
    message: "only powerpoint, word and pdf files are allowed and should not exceed 50 megabytes",
    size: { :in => 0..50000.kilobytes },
    if: Proc.new { |uploaded_file| uploaded_file.image_type == RESOURCE_FILE }

end

  def save_image_dimensions
    geo = Paperclip::Geometry.from_file(assets.queued_for_write[:original])
    self.image_width = geo.width
    self.image_height = geo.height
  end

# Unify the Paperclip options for attachments instead of duplicating them
# throughout the models code

# ASSET_IMAGE_CONTENT_TYPES = ['image/jpg', 'image/jpeg', 'image/gif', 'image/png', 'image/x-png', 'image/pjpeg']

# ASSET_VIDEO_CONTENT_TYPES = ["audio/mpeg","audio/mpg", "audio/x-mpeg", "audio/mp3","audio/x-mp3","audio/mpeg3","audio/x-mpeg3","audio/x-mpg","audio/x-mpegaudio","video/mp4","video/x-mp4","video/mv4","video/x-mv4","video/m4v","video/x-m4v"]

# ASSET_AUDIO_CONTENT_TYPES = ["audio/mpeg","audio/mpg", "audio/x-mpeg", "audio/mp3","audio/x-mp3","audio/mpeg3","audio/x-mpeg3","audio/x-mpg","audio/x-mpegaudio","video/mp4","video/x-mp4","video/mv4","video/x-mv4","video/m4v","video/x-m4v"]

# # use the same directory/file structure for all attachments: 0000/0000/file.style.ext
# ASSET_INTERPOLATION = ":partition/:basename:.style.:extension"

# DEFAULT_IMAGE_ATTACHMENT = {
#   :less_than      => 2.megabytes,
#   :default_style  => :original,
#   :styles         => {:original => "300x600", :thumb => "150x300"},
#   :content_type   => ASSET_IMAGE_CONTENT_TYPES,
#   :url            => "/assets/profile_images/"+ASSET_INTERPOLATION
# }

# CORP_IMAGE_ATTACHMENT = {
#   :less_than      => 4.megabytes,
#   :default_style  => :medium,
#   :styles         => {:small => "100x100", :medium => "200x200", :large => "300x300"},
#   :content_type   => ASSET_IMAGE_CONTENT_TYPES,
#   :url            => "/assets/corps/items/"+ASSET_INTERPOLATION
# }

# DEFAULT_PODCAST_ATTACHMENT = {
#   :less_than      => 25.megabytes,
#   :content_type   => ASSET_AUDIO_CONTENT_TYPES,
#   :url            => "/assets/podcasts/"+ASSET_INTERPOLATION
# }

# ASSETS = {
#   :media     => {:less_than => 100.megabytes,
#                  :url => "/assets/corps/media/"+ASSET_INTERPOLATION},
#                  #no content_type, any type can be uploaded

#   :podcast   => {:less_than => 100.megabytes,
#                  :url => "/assets/users/podcasts/"+ASSET_INTERPOLATION,
#                  :content_type => ASSET_AUDIO_CONTENT_TYPES},

#   :logo      => CORP_IMAGE_ATTACHMENT.merge({:less_than => 5.megabytes,
#                                              :url => "/assets/corps/logos/"+ASSET_INTERPOLATION}),
# }
#  