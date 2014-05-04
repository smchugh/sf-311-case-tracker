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

ActiveRecord::Schema.define(version: 20140504150328) do

  create_table "cases", force: true do |t|
    t.integer  "point_id",              limit: 8
    t.integer  "category_id"
    t.string   "request_details"
    t.integer  "request_type_id"
    t.integer  "status_id"
    t.datetime "updated"
    t.string   "media_url"
    t.integer  "neighborhood_id"
    t.integer  "sf_case_id",            limit: 8
    t.integer  "responsible_agency_id"
    t.datetime "opened"
    t.integer  "source_id"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cases", ["category_id"], name: "index_cases_on_category_id", using: :btree
  add_index "cases", ["neighborhood_id"], name: "index_cases_on_neighborhood_id", using: :btree
  add_index "cases", ["point_id"], name: "index_cases_on_point_id", using: :btree
  add_index "cases", ["request_type_id"], name: "index_cases_on_request_type_id", using: :btree
  add_index "cases", ["responsible_agency_id"], name: "index_cases_on_responsible_agency_id", using: :btree
  add_index "cases", ["sf_case_id"], name: "index_cases_on_sf_case_id", unique: true, using: :btree
  add_index "cases", ["source_id"], name: "index_cases_on_source_id", using: :btree
  add_index "cases", ["status_id"], name: "index_cases_on_status_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "neighborhoods", force: true do |t|
    t.string   "name"
    t.integer  "supervisor_district"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "neighborhoods", ["name"], name: "index_neighborhoods_on_name", unique: true, using: :btree

  create_table "points", force: true do |t|
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "needs_recoding"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points", ["longitude", "latitude"], name: "index_points_on_longitude_and_latitude", unique: true, using: :btree

  create_table "request_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "request_types", ["name"], name: "index_request_types_on_name", unique: true, using: :btree

  create_table "responsible_agencies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responsible_agencies", ["name"], name: "index_responsible_agencies_on_name", unique: true, using: :btree

  create_table "sources", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["name"], name: "index_sources_on_name", unique: true, using: :btree

  create_table "statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["name"], name: "index_statuses_on_name", unique: true, using: :btree

end
