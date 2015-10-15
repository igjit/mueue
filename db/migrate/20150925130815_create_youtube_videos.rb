class CreateYoutubeVideos < ActiveRecord::Migration
  def change
    create_table :youtube_videos do |t|
      t.string :resource_id, null: false, unique: true
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.string :thumbnail_url, null: false, default: ''

      t.timestamps null: false
    end
  end
end
