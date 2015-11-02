class YoutubeVideo < ActiveRecord::Base
  belongs_to :youtube_playlist
  has_many :youtube_playlist_youtube_video, dependent: :delete_all
  has_many :youtube_playlists, through: :youtube_playlist_youtube_video

  validates :resource_id, presence: true, uniqueness: true

  def watch_url
    "https://www.youtube.com/watch?v=#{resource_id}"
  end
end
