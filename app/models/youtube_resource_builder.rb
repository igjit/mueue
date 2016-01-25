require 'google/api_client'

class YoutubeResourceBuilder
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def initialize
    @client = Google::APIClient.new key: Settings.google.api_key, authorization: nil
    @youtube = @client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
  end

  def build_resources(playlist_id)
    response = @client.execute(api_method: @youtube.playlists.list, parameters: { part: 'snippet', id: playlist_id })
    fail unless response.success?

    channel = build_channel response
    playlist = build_playlist response

    parameters = { part: 'snippet', maxResults: 50, playlistId: playlist_id }
    items_response = @client.execute(api_method: @youtube.playlist_items.list, parameters: parameters)
    fail unless items_response.success?

    videos = build_videos items_response

    [channel, playlist, videos]
  end

  def inspect
    "#<#{self.class}:0x#{object_id.to_s(16)}>"
  end

  private

  def build_channel(response)
    item = response.data.items.first
    YoutubeChannel.new resource_id: item.snippet.channelId, title: item.snippet.channelTitle
  end

  def build_playlist(response)
    item = response.data.items.first
    YoutubePlaylist.new resource_id: item.id, title: item.snippet.title, thumbnail_url: item.snippet.thumbnails.medium.url
  end

  def build_videos(response)
    response.data.items.map do |item|
      YoutubeVideo.new(resource_id: item.snippet.resourceId.videoId, title: item.snippet.title,
                       description: item.snippet.description, thumbnail_url: item.snippet.thumbnails.medium.url)
    end
  end
end
