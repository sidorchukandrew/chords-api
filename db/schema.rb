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

ActiveRecord::Schema.define(version: 2022_03_31_041353) do

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

  create_table "capos", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "membership_id"
    t.string "capo_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_capos_on_membership_id"
    t.index ["song_id"], name: "index_capos_on_song_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "event_reminders", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_reminders_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.text "description"
    t.string "title"
    t.string "color"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "reminders_enabled"
    t.datetime "reminder_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_events_on_team_id"
  end

  create_table "events_memberships", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "membership_id", null: false
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
    t.string "font", default: "Roboto Mono"
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
    t.string "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "role_id"
    t.index ["role_id"], name: "index_memberships_on_role_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "color", default: "yellow"
    t.integer "line_number"
    t.text "content"
    t.bigint "song_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "team_id", null: false
    t.integer "x", default: 0
    t.integer "y", default: 0
    t.index ["song_id"], name: "index_notes_on_song_id"
    t.index ["team_id"], name: "index_notes_on_team_id"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.boolean "sms_enabled", default: false
    t.boolean "email_enabled", default: true
    t.boolean "push_enabled", default: false
    t.string "notification_type"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "onsong_imports", force: :cascade do |t|
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_onsong_imports_on_team_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "permissions_roles", id: false, force: :cascade do |t|
    t.bigint "permission_id", null: false
    t.bigint "role_id", null: false
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

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_admin", default: false
    t.boolean "is_member", default: false
    t.index ["team_id"], name: "index_roles_on_team_id"
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
    t.integer "scroll_speed", default: 1
    t.string "roadmap"
    t.index ["name"], name: "index_songs_on_name"
    t.index ["team_id"], name: "index_songs_on_team_id"
  end

  create_table "songs_themes", id: false, force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "theme_id", null: false
    t.index ["song_id", "theme_id"], name: "index_songs_themes_on_song_id_and_theme_id"
    t.index ["theme_id", "song_id"], name: "index_songs_themes_on_theme_id_and_song_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "user_id"
    t.string "plan_name"
    t.string "stripe_product_id"
    t.string "stripe_price_id"
    t.string "stripe_subscription_id"
    t.boolean "calendar_enabled", default: false
    t.integer "max_songs", default: 100
    t.integer "max_setlists", default: 25
    t.integer "max_binders", default: 5
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.index ["team_id"], name: "index_subscriptions_on_team_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
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

  create_table "tracks", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "team_id"
    t.string "url", default: ""
    t.string "artwork_url", default: ""
    t.string "external_id"
    t.string "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["song_id"], name: "index_tracks_on_song_id"
    t.index ["team_id"], name: "index_tracks_on_team_id"
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
    t.string "customer_id"
    t.string "phone_number"
    t.string "timezone", default: "America/New_York"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "binders", "teams"
  add_foreign_key "event_reminders", "events"
  add_foreign_key "events", "teams"
  add_foreign_key "notes", "teams"
  add_foreign_key "setlists", "teams"
  add_foreign_key "songs", "teams"
  add_foreign_key "themes", "teams"
end
