# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_28_221743) do

  create_table "binders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "color"
    t.integer "team_id"
    t.text "description"
    t.index "\"team\"", name: "index_binders_on_team"
    t.index ["team_id"], name: "index_binders_on_team_id"
  end

  create_table "binders_songs", force: :cascade do |t|
    t.integer "binder_id"
    t.integer "song_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["binder_id"], name: "index_binders_songs_on_binder_id"
    t.index ["song_id"], name: "index_binders_songs_on_song_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "genres_songs", id: false, force: :cascade do |t|
    t.integer "genre_id", null: false
    t.integer "song_id", null: false
    t.index ["genre_id", "song_id"], name: "index_genres_songs_on_genre_id_and_song_id"
    t.index ["song_id", "genre_id"], name: "index_genres_songs_on_song_id_and_genre_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email"
    t.integer "team_id"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["team_id"], name: "index_invitations_on_team_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.boolean "is_admin"
    t.string "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "name", null: false
    t.string "meter"
    t.string "artist"
    t.string "key"
    t.integer "bpm"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "team_id"
    t.string "font"
    t.integer "font_size"
    t.index "\"team\"", name: "index_songs_on_team"
    t.index ["name"], name: "index_songs_on_name"
    t.index ["team_id"], name: "index_songs_on_team_id"
  end

  create_table "songs_themes", id: false, force: :cascade do |t|
    t.integer "song_id", null: false
    t.integer "theme_id", null: false
    t.index ["song_id", "theme_id"], name: "index_songs_themes_on_song_id_and_theme_id"
    t.index ["theme_id", "song_id"], name: "index_songs_themes_on_theme_id_and_song_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "team_id"
    t.index "\"team\"", name: "index_themes_on_team"
    t.index ["name"], name: "index_themes_on_name"
    t.index ["team_id"], name: "index_themes_on_team_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "image_url"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

end
