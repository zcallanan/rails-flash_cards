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

ActiveRecord::Schema.define(version: 2020_06_16_113510) do

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
    t.bigint "tag_set_id", null: false
    t.bigint "card_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_card_tags_on_card_id"
    t.index ["tag_set_id"], name: "index_card_tags_on_tag_set_id"
  end

  create_table "cards", force: :cascade do |t|
    t.boolean "archive", default: false
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_cards_on_deck_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "collection_permissions", force: :cascade do |t|
    t.string "language"
    t.boolean "read_access", default: false
    t.boolean "update_access", default: false
    t.boolean "clone_access", default: false
    t.bigint "user_id", null: false
    t.bigint "collection_id", null: false
    t.bigint "collection_string_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["collection_id"], name: "index_collection_permissions_on_collection_id"
    t.index ["collection_string_id"], name: "index_collection_permissions_on_collection_string_id"
    t.index ["user_id"], name: "index_collection_permissions_on_user_id"
  end

  create_table "collection_strings", force: :cascade do |t|
    t.string "language"
    t.string "title"
    t.string "description"
    t.bigint "user_id", null: false
    t.bigint "collection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["collection_id"], name: "index_collection_strings_on_collection_id"
    t.index ["user_id"], name: "index_collection_strings_on_user_id"
  end

  create_table "collection_tags", force: :cascade do |t|
    t.bigint "tag_set_id", null: false
    t.bigint "collection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["collection_id"], name: "index_collection_tags_on_collection_id"
    t.index ["tag_set_id"], name: "index_collection_tags_on_tag_set_id"
  end

  create_table "collections", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.bigint "user_id", null: false
    t.boolean "global_collection_read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_collections_on_deck_id"
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "deck_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_deck_categories_on_category_id"
    t.index ["deck_id"], name: "index_deck_categories_on_deck_id"
  end

  create_table "deck_permissions", force: :cascade do |t|
    t.string "language"
    t.boolean "read_access", default: false
    t.boolean "update_access", default: false
    t.boolean "clone_access", default: false
    t.bigint "deck_id", null: false
    t.bigint "user_id", null: false
    t.bigint "deck_string_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_deck_permissions_on_deck_id"
    t.index ["deck_string_id"], name: "index_deck_permissions_on_deck_string_id"
    t.index ["user_id"], name: "index_deck_permissions_on_user_id"
  end

  create_table "deck_strings", force: :cascade do |t|
    t.string "language"
    t.string "title"
    t.string "description"
    t.bigint "user_id", null: false
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_deck_strings_on_deck_id"
    t.index ["user_id"], name: "index_deck_strings_on_user_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "default_language"
    t.bigint "user_id", null: false
    t.boolean "global_deck_read", default: false
    t.boolean "archived", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.string "user_label"
    t.string "email_contact"
    t.string "status", default: "Invited"
    t.boolean "read_access", default: false
    t.boolean "update_access", default: false
    t.bigint "user_id"
    t.bigint "user_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_group_id"], name: "index_memberships_on_user_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "question_set_permissions", force: :cascade do |t|
    t.string "language"
    t.boolean "read_access", default: false
    t.boolean "update_access", default: false
    t.boolean "clone_access", default: false
    t.bigint "user_id", null: false
    t.bigint "question_set_id", null: false
    t.bigint "question_set_string_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_set_id"], name: "index_question_set_permissions_on_question_set_id"
    t.index ["question_set_string_id"], name: "index_question_set_permissions_on_question_set_string_id"
    t.index ["user_id"], name: "index_question_set_permissions_on_user_id"
  end

  create_table "question_set_strings", force: :cascade do |t|
    t.string "language"
    t.string "title"
    t.string "description"
    t.bigint "user_id", null: false
    t.bigint "question_set_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_set_id"], name: "index_question_set_strings_on_question_set_id"
    t.index ["user_id"], name: "index_question_set_strings_on_user_id"
  end

  create_table "question_sets", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_question_sets_on_deck_id"
    t.index ["user_id"], name: "index_question_sets_on_user_id"
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

  create_table "tag_relations", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "tag_set_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_tag_relations_on_tag_id"
    t.index ["tag_set_id"], name: "index_tag_relations_on_tag_set_id"
  end

  create_table "tag_set_permissions", force: :cascade do |t|
    t.string "language"
    t.boolean "read_access", default: false
    t.boolean "update_access", default: false
    t.bigint "tag_set_id", null: false
    t.bigint "user_id", null: false
    t.bigint "tag_set_string_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_set_id"], name: "index_tag_set_permissions_on_tag_set_id"
    t.index ["tag_set_string_id"], name: "index_tag_set_permissions_on_tag_set_string_id"
    t.index ["user_id"], name: "index_tag_set_permissions_on_user_id"
  end

  create_table "tag_set_strings", force: :cascade do |t|
    t.string "title"
    t.string "language"
    t.string "description"
    t.bigint "user_id", null: false
    t.bigint "tag_set_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_set_id"], name: "index_tag_set_strings_on_tag_set_id"
    t.index ["user_id"], name: "index_tag_set_strings_on_user_id"
  end

  create_table "tag_sets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_tag_sets_on_deck_id"
    t.index ["user_id"], name: "index_tag_sets_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_group_collections", force: :cascade do |t|
    t.bigint "user_group_id", null: false
    t.bigint "collection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["collection_id"], name: "index_user_group_collections_on_collection_id"
    t.index ["user_group_id"], name: "index_user_group_collections_on_user_group_id"
  end

  create_table "user_group_decks", force: :cascade do |t|
    t.bigint "user_group_id", null: false
    t.bigint "deck_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_user_group_decks_on_deck_id"
    t.index ["user_group_id"], name: "index_user_group_decks_on_user_group_id"
  end

  create_table "user_group_question_sets", force: :cascade do |t|
    t.bigint "user_group_id", null: false
    t.bigint "question_set_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_set_id"], name: "index_user_group_question_sets_on_question_set_id"
    t.index ["user_group_id"], name: "index_user_group_question_sets_on_user_group_id"
  end

  create_table "user_group_tag_sets", force: :cascade do |t|
    t.bigint "user_group_id", null: false
    t.bigint "tag_set_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_set_id"], name: "index_user_group_tag_sets_on_tag_set_id"
    t.index ["user_group_id"], name: "index_user_group_tag_sets_on_user_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.string "language"
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
  add_foreign_key "card_tags", "tag_sets"
  add_foreign_key "cards", "decks"
  add_foreign_key "collection_cards", "cards"
  add_foreign_key "collection_cards", "collections"
  add_foreign_key "collection_permissions", "collection_strings"
  add_foreign_key "collection_permissions", "collections"
  add_foreign_key "collection_permissions", "users"
  add_foreign_key "collection_strings", "collections"
  add_foreign_key "collection_strings", "users"
  add_foreign_key "collection_tags", "collections"
  add_foreign_key "collection_tags", "tag_sets"
  add_foreign_key "collections", "decks"
  add_foreign_key "collections", "users"
  add_foreign_key "deck_categories", "categories"
  add_foreign_key "deck_categories", "decks"
  add_foreign_key "deck_permissions", "deck_strings"
  add_foreign_key "deck_permissions", "decks"
  add_foreign_key "deck_permissions", "users"
  add_foreign_key "deck_strings", "decks"
  add_foreign_key "deck_strings", "users"
  add_foreign_key "decks", "users"
  add_foreign_key "memberships", "user_groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "question_set_permissions", "question_set_strings"
  add_foreign_key "question_set_permissions", "question_sets"
  add_foreign_key "question_set_permissions", "users"
  add_foreign_key "question_set_strings", "question_sets"
  add_foreign_key "question_set_strings", "users"
  add_foreign_key "question_sets", "decks"
  add_foreign_key "question_sets", "users"
  add_foreign_key "question_strings", "questions"
  add_foreign_key "tag_relations", "tag_sets"
  add_foreign_key "tag_relations", "tags"
  add_foreign_key "tag_set_permissions", "tag_set_strings"
  add_foreign_key "tag_set_permissions", "tag_sets"
  add_foreign_key "tag_set_permissions", "users"
  add_foreign_key "tag_set_strings", "tag_sets"
  add_foreign_key "tag_set_strings", "users"
  add_foreign_key "tag_sets", "decks"
  add_foreign_key "tag_sets", "users"
  add_foreign_key "user_group_collections", "collections"
  add_foreign_key "user_group_collections", "user_groups"
  add_foreign_key "user_group_decks", "decks"
  add_foreign_key "user_group_decks", "user_groups"
  add_foreign_key "user_group_question_sets", "question_sets"
  add_foreign_key "user_group_question_sets", "user_groups"
  add_foreign_key "user_group_tag_sets", "tag_sets"
  add_foreign_key "user_group_tag_sets", "user_groups"
  add_foreign_key "user_groups", "users"
end
