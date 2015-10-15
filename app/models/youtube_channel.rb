class YoutubeChannel < ActiveRecord::Base
  has_many :youtube_playlists

  validates :resource_id, presence: true, uniqueness: true
end
