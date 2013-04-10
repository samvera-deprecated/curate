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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130408165026) do

  create_table "checksum_audit_logs", :force => true do |t|
    t.string   "pid"
    t.string   "dsid"
    t.string   "version"
    t.integer  "pass"
    t.string   "expected_result"
    t.string   "actual_result"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "checksum_audit_logs", ["pid", "dsid"], :name => "by_pid_and_dsid"

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "domain_terms", :force => true do |t|
    t.string "model"
    t.string "term"
  end

  add_index "domain_terms", ["model", "term"], :name => "terms_by_model_and_term"

  create_table "domain_terms_local_authorities", :id => false, :force => true do |t|
    t.integer "domain_term_id"
    t.integer "local_authority_id"
  end

  add_index "domain_terms_local_authorities", ["domain_term_id", "local_authority_id"], :name => "dtla_by_ids2"
  add_index "domain_terms_local_authorities", ["local_authority_id", "domain_term_id"], :name => "dtla_by_ids1"

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "help_requests", :force => true do |t|
    t.string   "view_port"
    t.text     "current_url"
    t.string   "user_agent"
    t.string   "resolution"
    t.text     "how_can_we_help_you"
    t.boolean  "javascript_enabled"
    t.string   "release_version"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "help_requests", ["created_at"], :name => "index_help_requests_on_created_at"
  add_index "help_requests", ["user_id"], :name => "index_help_requests_on_user_id"

  create_table "local_authorities", :force => true do |t|
    t.string "name"
  end

  create_table "local_authority_entries", :force => true do |t|
    t.integer "local_authority_id"
    t.string  "label"
    t.string  "uri"
  end

  add_index "local_authority_entries", ["local_authority_id", "label"], :name => "entries_by_term_and_label"
  add_index "local_authority_entries", ["local_authority_id", "uri"], :name => "entries_by_term_and_uri"

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
  end

  add_index "notifications", ["conversation_id"], :name => "index_notifications_on_conversation_id"

  create_table "object_access", :primary_key => "access_id", :force => true do |t|
    t.datetime "date_accessed"
    t.string   "ip_address"
    t.string   "host_name"
    t.string   "user_agent"
    t.string   "request_method"
    t.string   "path_info"
    t.integer  "repo_object_id"
    t.integer  "purl_id"
  end

  create_table "purl", :primary_key => "purl_id", :force => true do |t|
    t.integer  "repo_object_id"
    t.string   "access_count"
    t.datetime "last_accessed"
    t.string   "source_app"
    t.datetime "date_created"
  end

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "repo_object", :primary_key => "repo_object_id", :force => true do |t|
    t.string   "filename"
    t.string   "url"
    t.datetime "date_added"
    t.string   "add_source_ip"
    t.datetime "date_modified"
    t.string   "information"
  end

  create_table "single_use_links", :force => true do |t|
    t.string   "downloadKey"
    t.string   "path"
    t.string   "itemId"
    t.datetime "expires"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "subject_local_authority_entries", :force => true do |t|
    t.string "label"
    t.string "lowerLabel"
    t.string "url"
  end

  add_index "subject_local_authority_entries", ["lowerLabel"], :name => "entries_by_lower_label"

  create_table "trophies", :force => true do |t|
    t.integer  "user_id"
    t.string   "generic_file_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.boolean  "agreed_to_terms_of_service"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "version_committers", :force => true do |t|
    t.string   "obj_id"
    t.string   "datastream_id"
    t.string   "version_id"
    t.string   "committer_login"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_foreign_key "notifications", "conversations", :name => "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", :name => "receipts_on_notification_id"

end
