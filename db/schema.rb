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

ActiveRecord::Schema.define(version: 20141127134254) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auteurs", force: true do |t|
    t.text     "nom"
    t.text     "photo"
    t.text     "nationalite"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "naissance"
    t.integer  "mort"
  end

  create_table "editions", force: true do |t|
    t.text     "nom"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emplacements", force: true do |t|
    t.text     "nom"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", force: true do |t|
    t.text     "nom"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "livres", force: true do |t|
    t.text     "titre"
    t.integer  "auteur_id"
    t.integer  "edition_id"
    t.integer  "genre_id"
    t.integer  "emplacement_id"
    t.integer  "parution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "couverture"
    t.text     "achat"
    t.integer  "nb_pages"
    t.text     "description"
  end

  add_index "livres", ["auteur_id"], name: "index_livres_on_auteur_id", using: :btree
  add_index "livres", ["edition_id"], name: "index_livres_on_edition_id", using: :btree
  add_index "livres", ["emplacement_id"], name: "index_livres_on_emplacement_id", using: :btree
  add_index "livres", ["genre_id"], name: "index_livres_on_genre_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",            default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
