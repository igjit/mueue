if Settings.vlc_player.auto_start
  vlc = VLC::Client.new(Settings.vlc_player.host, Settings.vlc_player.port)

  25.times do
    begin
      vlc.connect
      break
    rescue
      Rails.logger.debug 'waiting...'
      sleep 5
    end
  end

  fail 'connect failure' unless vlc.connected?

  player = VLCPlayer.current
  player.play_state = :play if player.play_state != :play
  Rails.logger.debug "state: #{player.play_state}"
end
