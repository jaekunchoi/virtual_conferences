class Content < ActiveRecord::Base
  CONTENT_TYPE = {youtube_video: "Youtube Video",
                  slideshare: "Slideshare Presentation",
                  resource: "Resource"}
  
  include VideoHelper
  include PaperclipUploadedFile
                  
  resourcify
  
  belongs_to :venue
  belongs_to :owner_user, class_name: "User"
  belongs_to :sponsor_booth, class_name: "Booth"
  has_and_belongs_to_many :booths
  has_and_belongs_to_many :halls
  has_and_belongs_to_many :tags
  
  paperclip_file resource_file: UploadedFile::RESOURCE_FILE, 
                 thumbnail_image: UploadedFile::IMAGE_TYPE_THUMBNAIL
  
  validates :name, :content_type, :venue, #:owner_user, 
    :presence => true

  def sidebar_menu
    super ["Videos", "video-camera"], "video-nav", [[videos_path, "List videos"], [new_video_path, "Create a video"]], true
  end
  
  def valid_content?(depth = :deep)
    case content_type
      when CONTENT_TYPE[:youtube_video]
        external_id.present? && (depth == :shallow || video)
      when CONTENT_TYPE[:slideshare]
        external_id.present?
      when CONTENT_TYPE[:resource]
        external_id.present? or (resource_file.present? and resource_file.assets.present?)
      else
        false
    end
  end
  
  def video
    @video_obj ||= get_yt_video(self)
  end
end