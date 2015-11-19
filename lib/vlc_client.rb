module VLC
  class Client
    module PlaylistControls
      def playlist_raw
        connection.write("playlist")

        list = []
        begin
          list << connection.read
        end while list.last != PLAYLIST_TERMINATOR
        list
      end
    end
  end
end
