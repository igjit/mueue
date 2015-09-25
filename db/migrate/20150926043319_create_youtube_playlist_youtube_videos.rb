class CreateYoutubePlaylistYoutubeVideos < ActiveRecord::Migration
  def change
    create_table :youtube_playlist_youtube_videos do |t|
      t.references :youtube_playlist, index: true, foreign_key: true
      t.references :youtube_video, index: true, foreign_key: true
      t.integer :index

      t.timestamps null: false
    end
  end
end
