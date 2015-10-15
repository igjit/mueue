class YoutubePlaylistYoutubeVideo < ActiveRecord::Base
  belongs_to :youtube_playlist
  belongs_to :youtube_video

  validates_presence_of :youtube_playlist, :youtube_video
  validates_numericality_of :list_index, greater_than_or_equal_to: 1
end
