class CreateYoutubeVideos < ActiveRecord::Migration
  def change
    create_table :youtube_videos do |t|
      t.string :resource_id
      t.string :title
      t.text :description
      t.string :thumbnail_url

      t.timestamps null: false
    end
  end
end
