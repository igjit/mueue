class YoutubePlaylistYoutubeVideo < ActiveRecord::Base
  belongs_to :youtube_playlist
  belongs_to :youtube_video
end
