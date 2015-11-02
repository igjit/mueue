class VLCPlayer

  attr_reader :playlist_id

  def self.current
    @current ||= VLCPlayer.new
  end

  def self.current=(player)
    @current = player
  end

  def initialize
    @vlc = VLC::Client.new(Settings.vlc_player.host, Settings.vlc_player.port)
    @vlc.connect
    loop_on
    @playlist_id = nil
  end

  def playlist_id=(playlist_id)
    playlist = YoutubePlaylist.find(playlist_id)
    @playlist_id = playlist_id

    @vlc.clear
    videos = playlist.youtube_videos.ordered
    videos.each { |x| @vlc.add_to_playlist(x.watch_url) }
  end

  def track
    if @playlist_id && @vlc.playing?
      YoutubePlaylist.find(@playlist_id).youtube_videos.with_index.find_by(title: @vlc.title).list_index
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
