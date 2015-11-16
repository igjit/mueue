class PlayerController < ApplicationController
  def show
    player = VLCPlayer.current
    playlist_id = player.playlist_id

    if playlist_id && player.state == :play
      @playlist = YoutubePlaylist.find playlist_id
    end
  end
end
