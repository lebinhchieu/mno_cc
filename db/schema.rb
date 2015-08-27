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

ActiveRecord::Schema.define(version: 20150824061159) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advantages", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "advantages_real_estates", force: :cascade do |t|
    t.integer  "real_estate_id"
    t.integer  "advantage_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "appraisal_companies", force: :cascade do |t|
    t.text    "name"
    t.integer "avatar_image_id"
    t.integer "representative_id"
  end

  create_table "appraisal_companies_real_estates", force: :cascade do |t|
    t.integer  "appraisal_company_id"
    t.integer  "real_estate_id"
    t.datetime "assigned_time"
    t.text     "sell_price"
    t.boolean  "is_selected",          default: false
    t.boolean  "is_assigned"
    t.text     "rent_price"
    t.text     "status"
    t.text     "analysis"
    t.text     "note"
    t.text     "params"
  end

  create_table "appraisal_companies_users", force: :cascade do |t|
    t.integer "appraisal_company_id"
    t.integer "user_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.text    "name"
    t.text    "description"
    t.integer "project_id"
    t.integer "floor_number"
    t.integer "direction_id"
  end

  create_table "constructional_levels", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "currencies", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "directions", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "disadvantages", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "disadvantages_real_estates", force: :cascade do |t|
    t.integer  "real_estate_id"
    t.integer  "disadvantage_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "districts", force: :cascade do |t|
    t.text    "name"
    t.text    "code"
    t.integer "province_id"
    t.integer "order"
    t.text    "options"
  end

  create_table "images", force: :cascade do |t|
    t.text     "folder"
    t.text     "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "name"
    t.text     "type"
  end

  create_table "images_projects", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images_real_estates", force: :cascade do |t|
    t.integer  "real_estate_id"
    t.integer  "image_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "investors", force: :cascade do |t|
    t.text     "name"
    t.text     "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_groups", force: :cascade do |t|
    t.text    "name"
    t.text    "description"
    t.decimal "using_area"
    t.integer "restroom_number"
    t.integer "bedroom_number"
    t.decimal "width_x"
    t.decimal "width_y"
    t.text    "options"
  end

  create_table "items", force: :cascade do |t|
    t.integer "item_group_id"
    t.integer "block_id"
    t.integer "floor_number"
    t.integer "position"
    t.text    "description"
  end

  create_table "legal_record_types", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "mail_boxes", force: :cascade do |t|
    t.integer  "to_id"
    t.integer  "from_id"
    t.text     "subject"
    t.text     "content"
    t.integer  "attachment_file_id"
    t.boolean  "is_draft"
    t.datetime "created_at"
    t.text     "type"
    t.integer  "reply_id"
    t.boolean  "is_from_remove",     default: false
    t.boolean  "is_to_remove",       default: false
    t.text     "params"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "planning_status_types", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "project_types", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.integer  "province_id"
    t.integer  "district_id"
    t.integer  "street_id"
    t.text     "address_number"
    t.integer  "project_type_id"
    t.decimal  "campus_area"
    t.decimal  "width_x"
    t.decimal  "width_y"
    t.decimal  "using_ratio"
    t.datetime "estimate_starting_date"
    t.datetime "estimate_finishing_date"
    t.datetime "starting_date"
    t.datetime "finished_base_date"
    t.datetime "transfer_date"
    t.datetime "docs_issue_date"
    t.integer  "investor_id"
    t.text     "execute_unit"
    t.text     "design_unit"
    t.text     "manage_unit"
    t.text     "payment_method"
    t.decimal  "unit_price"
    t.integer  "currency_id"
    t.integer  "is_show",                 default: 1
    t.integer  "is_pending",              default: 1
    t.integer  "ward_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_draft"
    t.text     "lat"
    t.text     "long"
  end

  create_table "property_utilities", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "property_utilities_real_estates", force: :cascade do |t|
    t.integer  "real_estate_id"
    t.integer  "property_utility_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "provinces", force: :cascade do |t|
    t.text    "name"
    t.text    "code"
    t.integer "order"
    t.text    "options"
  end

  create_table "purposes", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "real_estate_types", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "real_estate_utilities", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "real_estates", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.text     "title"
    t.text     "description"
    t.integer  "purpose_id"
    t.decimal  "rent_price"
    t.integer  "currency_id"
    t.integer  "rent_unit_id"
    t.integer  "is_negotiable"
    t.integer  "province_id"
    t.integer  "district_id"
    t.integer  "ward_id"
    t.integer  "street_id"
    t.text     "address_number"
    t.integer  "street_type"
    t.integer  "is_alley"
    t.decimal  "alley_width"
    t.integer  "real_estate_type_id"
    t.decimal  "campus_area"
    t.decimal  "using_area"
    t.integer  "floor_number"
    t.integer  "restroom_number"
    t.integer  "bedroom_number"
    t.integer  "direction_id"
    t.integer  "build_year"
    t.integer  "constructional_quality"
    t.decimal  "constructional_area"
    t.integer  "constructional_level_id"
    t.decimal  "width_x"
    t.decimal  "width_y"
    t.integer  "shape"
    t.decimal  "shape_width"
    t.integer  "legal_record_type_id"
    t.text     "custom_legal_record_type"
    t.integer  "planning_status_type_id"
    t.text     "custom_planning_status_type"
    t.text     "custom_advantages"
    t.text     "custom_disadvantages"
    t.integer  "is_show",                     default: 1
    t.datetime "expired_time"
    t.decimal  "ads_cost"
    t.integer  "is_paid",                     default: 1
    t.text     "options"
    t.integer  "is_pending",                  default: 1
    t.integer  "is_draft",                    default: 0
    t.decimal  "sell_price"
    t.integer  "sell_unit_id"
    t.text     "lat"
    t.text     "long"
    t.text     "meta_search"
    t.integer  "user_id"
    t.integer  "appraisal_purpose"
    t.integer  "appraisal_type",              default: 0
    t.text     "appraisal_price"
  end

  create_table "real_estates_region_utilities", force: :cascade do |t|
    t.integer  "real_estate_id"
    t.integer  "region_utility_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "region_utilities", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "status_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "streets", force: :cascade do |t|
    t.text    "name"
    t.text    "code"
    t.integer "province_id"
    t.integer "order"
    t.text    "options"
  end

  create_table "units", force: :cascade do |t|
    t.text     "name"
    t.text     "code"
    t.text     "options"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order"
  end

  create_table "users", force: :cascade do |t|
    t.text     "account"
    t.text     "password"
    t.text     "email"
    t.text     "full_name"
    t.date     "birthday"
    t.text     "business_name"
    t.text     "phone_number"
    t.text     "address"
    t.integer  "avatar_image_id"
    t.boolean  "is_system_manager",      default: false
    t.boolean  "is_real_estate_manager", default: false
    t.boolean  "is_project_manager",     default: false
    t.boolean  "is_user_manager",        default: false
    t.boolean  "is_appraiser",           default: false
    t.boolean  "is_statistician",        default: false
    t.boolean  "is_admin",               default: false
    t.text     "provider"
    t.text     "provider_user_id"
    t.text     "provider_token"
    t.datetime "provider_expires_at"
  end

  create_table "wards", force: :cascade do |t|
    t.text    "name"
    t.text    "code"
    t.integer "province_id"
    t.integer "order"
    t.text    "options"
  end

end
