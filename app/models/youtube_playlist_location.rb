class YoutubePlaylistLocation
  include ActiveModel::Model

  attr_accessor :url

  validate :correct_url
  validate :unique_playlist

  def save_resources!
    resource_builder = YoutubeResourceBuilder.new

    channel, playlist, videos = resource_builder.build_resources resource_id

    ActiveRecord::Base.transaction do
      channel = YoutubeChannel.find_or_create_by(resource_id: channel.resource_id) { |x| x.attributes = channel.attributes }

      unless YoutubePlaylist.exists?(resource_id: playlist.resource_id)
        playlist.youtube_channel = channel
        playlist.save!
        videos.map! do |video|
          YoutubeVideo.find_or_create_by(resource_id: video.resource_id) { |x| x.attributes = video.attributes }
        end
        playlist.update_youtube_videos! videos
      end
    end
  end

  def save_resources
    save_resources!
    true
  rescue
    errors.add(:base, 'failed to save')
    false
  end

  def resource_id
    extract_playlist_id(@url) rescue nil
  end

  private

  def extract_playlist_id(url)
    uri = URI.parse url
    alist = URI.decode_www_form(uri.query)
    Hash[alist]['list']
  end

  def correct_url
    errors.add(:url, "doesn't seem to be a playlist") unless resource_id
  end

  def unique_playlist
    if resource_id && YoutubePlaylist.exists?(resource_id: resource_id)
      errors.add(:base, 'playlist already exists')
    end
  end
end
