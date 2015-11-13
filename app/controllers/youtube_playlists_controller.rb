class YoutubePlaylistsController < ApplicationController
  before_action :set_playlist, only: [:destroy]

  def index
    @playlists = YoutubePlaylist.all.includes(:youtube_channel)
  end

  def new
    @location = YoutubePlaylistLocation.new
  end

  def create
    @location = YoutubePlaylistLocation.new
    @location.url = params[:youtube_playlist_location][:url]
    if @location.valid? && @location.save_resources
      redirect_to youtube_playlists_url, notice: 'Playlist was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @playlist.destroy
    redirect_to youtube_playlists_url, notice: 'Playlist was successfully destroyed.'
  end

  private

  def set_playlist
    @playlist = YoutubePlaylist.find(params[:id])
  end
end
