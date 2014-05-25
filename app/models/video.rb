class Video < ActiveRecord::Base
  resourcify
  belongs_to :asset_type
  belongs_to :user
  belongs_to :hall
  
  
  has_and_belongs_to_many :booths
  
  belongs_to :sponsor, class_name: "Booth"
  has_one :thumbnail, ->{where(:image_type => UploadedFile::IMAGE_TYPE_STANDARD)}, as: :imageable, class_name: 'UploadedFile', dependent: :destroy
  has_one :holding_image_start, ->{where(:image_type => UploadedFile::HOLDING_IMAGE_START)}, as: :imageable, class_name: 'UploadedFile', dependent: :destroy
  has_one :holding_image_finish, ->{where(:image_type => UploadedFile::HOLDING_IMAGE_FINISH)}, as: :imageable, class_name: 'UploadedFile', dependent: :destroy
  has_one :holding_image_qna, ->{where(:image_type => UploadedFile::HOLDING_IMAGE_QNA)}, as: :imageable, class_name: 'UploadedFile', dependent: :destroy
  accepts_nested_attributes_for :thumbnail, :holding_image_start, :holding_image_finish, :holding_image_qna, :reject_if => proc { |attributes| attributes['assets'].blank? }

  validates :name, :user_id, :presence => true
  validates :yt_youtube_id, :url => false

  scope :completes, -> { where(:is_complete => true) }
  scope :incompletes, -> { where(:is_complete => false) }

  def self.yt_session
    @yt_session ||= YouTubeIt::Client.new(:username => YouTubeITConfig.username , :password => YouTubeITConfig.password , :dev_key => YouTubeITConfig.dev_key)
  end

  def self.delete_video(video)
    yt_session.video_delete(video.yt_youtube_id)
    video.destroy
      rescue
        video.destroy
  end

  def self.update_video(video, params)
    yt_session.video_update(video.yt_youtube_id, video_options(params))
    video.update_attributes(params)
  end

  def self.token_form(params, nexturl)
    yt_session.upload_token(video_options(params), nexturl)
  end

  def self.delete_incomplete_videos
    self.incompletes.map{|r| r.destroy}
  end

  private
    def self.video_options(params)
      opts = {:title => params[:name],
             :description => params[:description],
             :category => "People",
             :keywords => ["conferences"]}
      params[:is_unpublished] == "1" ? opts.merge(:private => "true") : opts
    end
end
