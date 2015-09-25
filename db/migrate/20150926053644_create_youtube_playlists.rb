class CreateYoutubePlaylists < ActiveRecord::Migration
  def change
    create_table :youtube_playlists do |t|
      t.references :youtube_channel, index: true, foreign_key: true
      t.string :resource_id
      t.string :title
      t.text :description
      t.string :thumbnail_url

      t.timestamps null: false
    end
  end
end
