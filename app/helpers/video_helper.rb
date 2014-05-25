module VideoHelper
  include ActionView::Helpers::AssetTagHelper
  
  def get_yt_video(video)
    begin
      return nil if video.content_type != Content::CONTENT_TYPE[:youtube_video] 
      get_yt_session().video_by(video.external_id) 
    rescue
      nil
    end
  end
  
  def get_yt_session()
    @yt_session ||= YouTubeIt::Client.new(:username => YouTubeITConfig.username , :password => YouTubeITConfig.password , :dev_key => YouTubeITConfig.dev_key)
  end
end