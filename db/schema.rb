# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151119122426) do

  create_table "player_states", force: :cascade do |t|
    t.integer  "youtube_playlist_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "player_states", ["youtube_playlist_id"], name: "index_player_states_on_youtube_playlist_id"

  create_table "youtube_channels", force: :cascade do |t|
    t.string   "resource_id",              null: false
    t.string   "title",       default: "", null: false
    t.text     "description", default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "youtube_playlist_youtube_videos", force: :cascade do |t|
    t.integer  "youtube_playlist_id", null: false
    t.integer  "youtube_video_id",    null: false
    t.integer  "list_index",          null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "youtube_playlist_youtube_videos", ["youtube_playlist_id"], name: "index_youtube_playlist_youtube_videos_on_youtube_playlist_id"
  add_index "youtube_playlist_youtube_videos", ["youtube_video_id"], name: "index_youtube_playlist_youtube_videos_on_youtube_video_id"

  create_table "youtube_playlists", force: :cascade do |t|
    t.integer  "youtube_channel_id",              null: false
    t.string   "resource_id",                     null: false
    t.string   "title",              default: "", null: false
    t.text     "description",        default: "", null: false
    t.string   "thumbnail_url",      default: "", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "youtube_playlists", ["youtube_channel_id"], name: "index_youtube_playlists_on_youtube_channel_id"

  create_table "youtube_videos", force: :cascade do |t|
    t.string   "resource_id",                null: false
    t.string   "title",         default: "", null: false
    t.text     "description",   default: "", null: false
    t.string   "thumbnail_url", default: "", null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end
