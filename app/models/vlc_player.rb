class VLCPlayer
  PLAYER_STATE_ID = 1

  def self.current
    @current ||= VLCPlayer.new
  end

  def self.current=(player)
    @current = player
  end

  def initialize
    @vlc = VLC::Client.new(Settings.vlc_player.host, Settings.vlc_player.port)
    @vlc.connect
    PlayerState.find_or_create_by(id: PLAYER_STATE_ID)
    loop_on
  end

  def playlist_id
    PlayerState.find(PLAYER_STATE_ID).youtube_playlist_id
  end

  def playlist_id=(playlist_id)
    playlist = YoutubePlaylist.find(playlist_id)

    @vlc.clear
    videos = playlist.youtube_videos.ordered
    videos.each { |x| @vlc.add_to_playlist(x.watch_url) }

    PlayerState.find(PLAYER_STATE_ID).update! youtube_playlist_id: playlist_id
  end

  def track
    title = @vlc.title
    if title.present?
      index = @vlc.playlist_raw.grep(/^\|\s{3}\d+\s-\s/).find_index { |x| x.index title }
      index ? (index + 1) : nil
    end
  end

  def state
    { play_state: play_state, playlist_id: playlist_id, track: track }.compact
  end

  def state=(state)
    self.playlist_id = state[:playlist_id].to_i if state[:playlist_id]
    self.play_state = state[:play_state] if state[:play_state]
  end

  def play_state
    if @vlc.playing?
      :play
    else
      :stop
    end
  end

  def play_state=(state)
    case state.to_sym
    when :play
      @vlc.play
      # FIXME
      sleep 0.5
      @vlc.play
    when :stop
      @vlc.stop
    else
      fail "unknown state: #{state}"
    end
  end

  private

  def loop_on
    @vlc.connection.write 'loop on'
  end
end
