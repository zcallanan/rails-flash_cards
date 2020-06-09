# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_09_124448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "answer"
    t.datetime "answer_date"
    t.bigint "user_id", null: false
    t.bigint "card_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_answers_on_card_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "card_question_sets", force: :cascade do |t|
    t.bigint "question_set_id", null: false
    t.bigint "card_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_card_question_sets_on_card_id"
    t.index ["question_id"], name: "index_card_question_sets_on_question_id"
    t.index ["question_set_id"], name: "index_card_question_sets_on_question_set_id"
  end

  create_table "card_strings", force: :cascade do |t|
    t.string "language"
    t.string "title"
    t.string "body"
    t.bigint "card_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_card_strings_on_card_id"
  end

  create_table "card_tags", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_card_tags_on_card_id"
    t.index ["tag_id"], name: "index_card_tags_on_tag_id"
  end

  create_table "cards", force: :cascade do |t|
    t.boolean "archive", default: false
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_cards_on_deck_id"
  end

  create_table "collection_cards", force: :cascade do |t|
    t.integer "priority"
    t.integer "view_count", default: 0
    t.bigint "card_id", null: false
    t.bigint "collection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_collection_cards_on_card_id"
    t.index ["collection_id"], name: "index_collection_cards_on_collection_id"
  end

  create_table "collection_strings", force: :cascade do |t|
    t.string "language"
    t.string "title"
    t.string "description"
    t.bigint "collection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["collection_id"], name: "index_collection_strings_on_collection_id"
  end

  create_table "collection_tags", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["collection_id"], name: "index_collection_tags_on_collection_id"
    t.index ["tag_id"], name: "index_collection_tags_on_tag_id"
  end

  create_table "collections", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_collections_on_deck_id"
  end

  create_table "deck_permissions", force: :cascade do |t|
    t.integer "access_level", default: 0
    t.boolean "creator", default: false
    t.bigint "deck_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_deck_permissions_on_deck_id"
    t.index ["user_id"], name: "index_deck_permissions_on_user_id"
  end

  create_table "deck_strings", force: :cascade do |t|
    t.string "language"
    t.string "title"
    t.string "description"
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_deck_strings_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "question_sets", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_question_sets_on_deck_id"
  end

  create_table "question_strings", force: :cascade do |t|
    t.string "language"
    t.string "question"
    t.integer "field_type", default: 0
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_question_strings_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "cards"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "card_question_sets", "cards"
  add_foreign_key "card_question_sets", "question_sets"
  add_foreign_key "card_question_sets", "questions"
  add_foreign_key "card_strings", "cards"
  add_foreign_key "card_tags", "cards"
  add_foreign_key "card_tags", "tags"
  add_foreign_key "cards", "decks"
  add_foreign_key "collection_cards", "cards"
  add_foreign_key "collection_cards", "collections"
  add_foreign_key "collection_strings", "collections"
  add_foreign_key "collection_tags", "collections"
  add_foreign_key "collection_tags", "tags"
  add_foreign_key "collections", "decks"
  add_foreign_key "deck_permissions", "decks"
  add_foreign_key "deck_permissions", "users"
  add_foreign_key "deck_strings", "decks"
  add_foreign_key "question_sets", "decks"
  add_foreign_key "question_strings", "questions"
end
