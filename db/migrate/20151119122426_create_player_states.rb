class CreatePlayerStates < ActiveRecord::Migration
  def change
    create_table :player_states do |t|
      t.references :youtube_playlist, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
