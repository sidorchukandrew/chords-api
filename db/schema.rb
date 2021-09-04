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

ActiveRecord::Schema.define(version: 2021_09_04_014709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "binders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "color"
    t.bigint "team_id"
    t.text "description"
    t.index ["team_id"], name: "index_binders_on_team_id"
  end

  create_table "binders_songs", force: :cascade do |t|
    t.bigint "binder_id"
    t.bigint "song_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["binder_id"], name: "index_binders_songs_on_binder_id"
    t.index ["song_id"], name: "index_binders_songs_on_song_id"
  end

  create_table "format_configurations", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "song_id"
    t.bigint "user_id"
    t.bigint "format_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["format_id"], name: "index_format_configurations_on_format_id"
    t.index ["song_id"], name: "index_format_configurations_on_song_id"
    t.index ["team_id"], name: "index_format_configurations_on_team_id"
    t.index ["user_id"], name: "index_format_configurations_on_user_id"
  end

  create_table "formats", force: :cascade do |t|
    t.string "font", default: "Open Sans"
    t.integer "font_size", default: 18
    t.boolean "bold_chords", default: false
    t.boolean "italic_chords", default: false
    t.string "chords_color"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_default"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "genres_songs", id: false, force: :cascade do |t|
    t.bigint "genre_id", null: false
    t.bigint "song_id", null: false
    t.index ["genre_id", "song_id"], name: "index_genres_songs_on_genre_id_and_song_id"
    t.index ["song_id", "genre_id"], name: "index_genres_songs_on_song_id_and_genre_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email"
    t.bigint "team_id"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["team_id"], name: "index_invitations_on_team_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "team_id"
    t.boolean "is_admin"
    t.string "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "public_setlists", force: :cascade do |t|
    t.bigint "setlist_id"
    t.string "code"
    t.datetime "expires_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_active", default: false
    t.index ["setlist_id"], name: "index_public_setlists_on_setlist_id"
  end

  create_table "scheduled_songs", force: :cascade do |t|
    t.bigint "setlist_id"
    t.bigint "song_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["setlist_id"], name: "index_scheduled_songs_on_setlist_id"
    t.index ["song_id"], name: "index_scheduled_songs_on_song_id"
  end

  create_table "setlists", force: :cascade do |t|
    t.string "name"
    t.date "scheduled_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "team_id"
    t.index ["team_id"], name: "index_setlists_on_team_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "name", null: false
    t.string "meter"
    t.string "artist"
    t.string "original_key"
    t.integer "bpm"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "team_id"
    t.string "source"
    t.string "transposed_key"
    t.index ["name"], name: "index_songs_on_name"
    t.index ["team_id"], name: "index_songs_on_team_id"
  end

  create_table "songs_themes", id: false, force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "theme_id", null: false
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
    t.bigint "team_id"
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
    t.string "pco_access_token"
    t.string "pco_refresh_token"
    t.datetime "pco_token_expires_at"
    t.boolean "is_admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "binders", "teams"
  add_foreign_key "setlists", "teams"
  add_foreign_key "songs", "teams"
  add_foreign_key "themes", "teams"
end
