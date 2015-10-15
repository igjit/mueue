class CreateYoutubeChannels < ActiveRecord::Migration
  def change
    create_table :youtube_channels do |t|
      t.string :resource_id, null: false, unique: true
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''

      t.timestamps null: false
    end
  end
end
