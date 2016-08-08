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

ActiveRecord::Schema.define(version: 20160808000859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hashtags", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "occurrences", force: :cascade do |t|
    t.string   "occurrable_type"
    t.integer  "occurrable_id"
    t.datetime "tweeted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["occurrable_type", "occurrable_id"], name: "index_occurrences_on_occurrable_type_and_occurrable_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string "value"
  end

  create_table "topics_hashtags", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "hashtag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashtag_id"], name: "index_topics_hashtags_on_hashtag_id", using: :btree
    t.index ["topic_id"], name: "index_topics_hashtags_on_topic_id", using: :btree
  end

  create_table "topics_urls", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "url_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_topics_urls_on_topic_id", using: :btree
    t.index ["url_id"], name: "index_topics_urls_on_url_id", using: :btree
  end

  create_table "topics_user_mentions", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "user_mention_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["topic_id"], name: "index_topics_user_mentions_on_topic_id", using: :btree
    t.index ["user_mention_id"], name: "index_topics_user_mentions_on_user_mention_id", using: :btree
  end

  create_table "urls", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_mentions", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
