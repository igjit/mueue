class VLCPlayer
  PLAYER_STATE_ID = 1
  CONTROLS = %i(next previous)
  VLC_POLLING_INTERVAL = 10

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
    self.playlist_id = playlist_id if playlist_id && play_state == :stop
    start_poll if need_poll?
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
    { play_state: play_state, playlist_id: playlist_id, track: track, volume: volume }.compact
  end

  def state=(state)
    self.playlist_id = state[:playlist_id].to_i if state[:playlist_id]
    self.play_state = state[:play_state] if state[:play_state]
    self.volume = state[:volume].to_i if state[:volume]
    control(state[:control]) if state[:control]
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

  def volume
    @vlc.volume
  end

  def volume=(volume)
    fail unless 0 <= volume && volume < 256
    @vlc.volume = volume
  end

  def control(control)
    fail ArgumentError, "unknown control: #{control}" unless CONTROLS.include? control.to_sym
    @vlc.send control
  end

  private

  def loop_on
    @vlc.connection.write 'loop on'
  end

  def need_poll?
    Settings.slack.webhook_url.present?
  end

  def start_poll
    @prev_title = nil
    scheduler = Rufus::Scheduler.new
    @job = scheduler.repeat "#{VLC_POLLING_INTERVAL}s", overlap: false do
      current_title = @vlc.title
      if current_title.present? && current_title !~ %r{^https?://} && current_title != @prev_title
        Rails.logger.debug "Title changed: '#{@prev_title}' => '#{current_title}'"
        notify_to_slack
        @prev_title = current_title
      end
    end
  end

  def notify_to_slack
    url = Settings.slack.webhook_url
    if url
      playlist = YoutubePlaylist.find(playlist_id)
      video = playlist.youtube_videos.ordered[state[:track] - 1]
      text = "<#{video.watch_url}|#{video.title}> in <#{playlist.watch_url}|#{playlist.title}>"

      SlackNotificationJob.perform_later url, username: 'Now Playing', icon_emoji: ':musical_note:', text: text, unfurl_media: false
    end
  end
end
