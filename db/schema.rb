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

ActiveRecord::Schema.define(version: 20190321102502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "first_name"
    t.string   "last_name"
    t.decimal  "balance",                default: 0.0
    t.integer  "essays_count",           default: 0
    t.string   "timezone",               default: "Nairobi"
    t.integer  "role",                   default: 0,         null: false
    t.string   "slug"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["slug"], name: "index_admins_on_slug", unique: true, using: :btree

  create_table "attachments", force: true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "essays_count",     default: 0
    t.text     "content"
    t.string   "title"
    t.string   "meta_description"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "coupons", force: true do |t|
    t.string   "code"
    t.string   "description"
    t.float    "amount"
    t.integer  "redemption_limit", default: 1
    t.string   "coupon_type",      default: "percentage"
    t.datetime "valid_from"
    t.datetime "valid_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["code"], name: "index_coupons_on_code", unique: true, using: :btree

  create_table "emails", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "subject"
    t.string   "address"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "essays", force: true do |t|
    t.string   "title"
    t.float    "price"
    t.integer  "page_count"
    t.integer  "word_count"
    t.string   "short_description"
    t.text     "question"
    t.text     "preview"
    t.string   "slug"
    t.integer  "referencing_style_id"
    t.integer  "category_id"
    t.integer  "download_count",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "document_fingerprint"
    t.integer  "status",                default: 0, null: false
  end

  add_index "essays", ["category_id"], name: "index_essays_on_category_id", using: :btree
  add_index "essays", ["document_fingerprint"], name: "index_essays_on_document_fingerprint", unique: true, using: :btree
  add_index "essays", ["referencing_style_id"], name: "index_essays_on_referencing_style_id", using: :btree
  add_index "essays", ["slug"], name: "index_essays_on_slug", unique: true, using: :btree

  create_table "faqs", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "froala_uploads", force: true do |t|
    t.string   "name"
    t.integer  "file_size"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.float    "amount"
    t.text     "message"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "payer_email"
    t.string   "payer_id"
    t.string   "txn_id"
    t.string   "residence_country"
    t.string   "payment_status",    default: "pending"
    t.datetime "payment_date"
    t.string   "payment_token"
    t.float    "mc_fee"
    t.float    "mc_gross"
    t.string   "verify_sign"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["order_id"], name: "index_invoices_on_order_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "order_id"
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["order_id"], name: "index_messages_on_order_id", using: :btree
  add_index "messages", ["user_id", "user_type"], name: "index_messages_on_user_id_and_user_type", using: :btree

  create_table "orders", force: true do |t|
    t.string   "topic",             default: "Writer's Choice"
    t.string   "academic_level",    default: "college"
    t.string   "paper_type"
    t.string   "discipline"
    t.string   "citation_style",    default: "MLA"
    t.integer  "hours_to_deadline", default: 72
    t.datetime "due_at"
    t.string   "sources",           default: "0"
    t.string   "pages",             default: "1"
    t.string   "spacing",           default: "double"
    t.text     "instructions"
    t.integer  "status",            default: 0,                 null: false
    t.string   "uid"
    t.string   "slug"
    t.integer  "student_id"
    t.boolean  "inquiry",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assigned_to_id"
  end

  add_index "orders", ["assigned_to_id"], name: "index_orders_on_assigned_to_id", using: :btree
  add_index "orders", ["student_id"], name: "index_orders_on_student_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["slug"], name: "index_pages_on_slug", unique: true, using: :btree

  create_table "payouts", force: true do |t|
    t.decimal  "amount"
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payouts", ["user_id", "user_type"], name: "index_payouts_on_user_id_and_user_type", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "meta_description"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.boolean  "draft",               default: true
    t.integer  "category_id"
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree

  create_table "purchases", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "payer_email"
    t.string   "payer_id"
    t.string   "txn_id"
    t.string   "residence_country"
    t.string   "payment_status"
    t.datetime "payment_date"
    t.string   "payment_token"
    t.float    "mc_fee"
    t.float    "mc_gross"
    t.string   "verify_sign"
    t.integer  "essay_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "purchases", ["essay_id"], name: "index_purchases_on_essay_id", using: :btree
  add_index "purchases", ["payment_token"], name: "index_purchases_on_payment_token", unique: true, using: :btree
  add_index "purchases", ["slug"], name: "index_purchases_on_slug", unique: true, using: :btree

  create_table "questions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "slug"
    t.text     "retrieved_from"
    t.integer  "status",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by_id"
  end

  add_index "questions", ["retrieved_from"], name: "index_questions_on_retrieved_from", unique: true, using: :btree
  add_index "questions", ["slug"], name: "index_questions_on_slug", unique: true, using: :btree
  add_index "questions", ["title"], name: "index_questions_on_title", using: :btree

  create_table "redemptions", force: true do |t|
    t.integer  "coupon_id"
    t.integer  "student_id"
    t.integer  "order_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redemptions", ["coupon_id"], name: "index_redemptions_on_coupon_id", using: :btree
  add_index "redemptions", ["order_id"], name: "index_redemptions_on_order_id", using: :btree
  add_index "redemptions", ["student_id"], name: "index_redemptions_on_student_id", using: :btree

  create_table "referencing_styles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referencing_styles", ["name"], name: "index_referencing_styles_on_name", unique: true, using: :btree

  create_table "reviews", force: true do |t|
    t.text     "content"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["order_id"], name: "index_reviews_on_order_id", using: :btree

  create_table "sellers", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "slug"
    t.decimal  "balance",                default: 0.0
    t.string   "paypal_email"
    t.integer  "essays_count",           default: 0
    t.string   "timezone",               default: "UTC"
    t.integer  "role",                   default: 0,     null: false
  end

  add_index "sellers", ["confirmation_token"], name: "index_sellers_on_confirmation_token", unique: true, using: :btree
  add_index "sellers", ["email"], name: "index_sellers_on_email", unique: true, using: :btree
  add_index "sellers", ["paypal_email"], name: "index_sellers_on_paypal_email", unique: true, using: :btree
  add_index "sellers", ["reset_password_token"], name: "index_sellers_on_reset_password_token", unique: true, using: :btree
  add_index "sellers", ["slug"], name: "index_sellers_on_slug", unique: true, using: :btree
  add_index "sellers", ["username"], name: "index_sellers_on_username", unique: true, using: :btree

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "country"
    t.string   "timezone",               default: "UTC"
    t.string   "slug"
    t.integer  "orders_count",           default: 0
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "students", ["email"], name: "index_students_on_email", unique: true, using: :btree
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true, using: :btree
  add_index "students", ["slug"], name: "index_students_on_slug", unique: true, using: :btree

  create_table "thumbnails", force: true do |t|
    t.integer  "essay_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "page_no"
  end

  add_index "thumbnails", ["essay_id"], name: "index_thumbnails_on_essay_id", using: :btree

  create_table "transactions", force: true do |t|
    t.string   "txn_type"
    t.string   "txn_id"
    t.decimal  "amount"
    t.decimal  "balance_before"
    t.decimal  "balance_after"
    t.text     "description"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "purchase_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "transactions", ["purchase_id"], name: "index_transactions_on_purchase_id", using: :btree
  add_index "transactions", ["slug"], name: "index_transactions_on_slug", unique: true, using: :btree

  create_table "withdrawals", force: true do |t|
    t.decimal  "amount"
    t.integer  "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_status", default: "Pending"
    t.string   "pay_key"
    t.text     "ipn_response"
  end

  add_index "withdrawals", ["seller_id"], name: "index_withdrawals_on_seller_id", using: :btree

  create_table "writers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "slug"
    t.integer  "orders_count",           default: 0,   null: false
    t.float    "rate_per_page",          default: 4.0, null: false
    t.decimal  "balance",                default: 0.0, null: false
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "writers", ["email"], name: "index_writers_on_email", unique: true, using: :btree
  add_index "writers", ["reset_password_token"], name: "index_writers_on_reset_password_token", unique: true, using: :btree
  add_index "writers", ["slug"], name: "index_writers_on_slug", unique: true, using: :btree

end
