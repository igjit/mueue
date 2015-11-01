class YoutubePlaylist < ActiveRecord::Base
  belongs_to :youtube_channel
  has_many :youtube_playlist_youtube_videos, dependent: :delete_all
  has_many :youtube_videos, through: :youtube_playlist_youtube_videos do
    def ordered
      order('youtube_playlist_youtube_videos.list_index')
    end
  end

  validates :resource_id, presence: true, uniqueness: true

  def update_youtube_videos!(videos)
    playlist_videos = videos.map.with_index(1) do |x, i|
      YoutubePlaylistYoutubeVideo.new youtube_playlist: self, youtube_video: x, list_index: i
    end
    self.youtube_playlist_youtube_videos = playlist_videos
  end

  def watch_url
    video_id = youtube_playlist_youtube_videos.find_by(list_index: 1).youtube_video.resource_id
    "https://www.youtube.com/watch?v=#{video_id}&list=#{resource_id}"
  end
end
