module Player
  class StatesController < ApplicationController
    def show
      state = player.state
      @volume = state[:volume]
      if state[:playlist_id] && state[:track]
        @playlist = YoutubePlaylist.find(state[:playlist_id])
        @video = @playlist.youtube_videos.ordered[state[:track] - 1]
      end

      respond_to do |format|
        format.html
        format.json { render json: { state: state } }
      end
    end

    def update
      player.state = state_params
      respond_to do |format|
        format.json { render json: { state: player.state } }
      end
    end

    private

    def state_params
      params.require(:state).permit(:play_state, :playlist_id, :track, :volume, :control)
    end

    def player
      VLCPlayer.current
    end
  end
end
