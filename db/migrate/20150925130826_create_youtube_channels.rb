class CreateYoutubeChannels < ActiveRecord::Migration
  def change
    create_table :youtube_channels do |t|
      t.string :resource_id
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
