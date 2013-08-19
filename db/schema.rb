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

ActiveRecord::Schema.define(:version => 20130818225930) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "name"
    t.boolean  "goodanswer",  :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "carts", :force => true do |t|
    t.integer  "coursefollow_id"
    t.integer  "follower_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "carts", ["coursefollow_id"], :name => "index_carts_on_coursefollow_id"
  add_index "carts", ["follower_id", "coursefollow_id"], :name => "index_carts_on_follower_id_and_coursefollow_id", :unique => true
  add_index "carts", ["follower_id"], :name => "index_carts_on_follower_id"

  create_table "courseratings", :force => true do |t|
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "course_id"
    t.text     "review_content"
    t.string   "review_title"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "courseratings", ["user_id", "course_id"], :name => "index_courseratings_on_user_id_and_course_id", :unique => true

  create_table "courseregistrations", :force => true do |t|
    t.integer  "courstudent_id"
    t.integer  "takencourse_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "courseregistrations", ["courstudent_id"], :name => "index_courseregistrations_on_courstudent_id"
  add_index "courseregistrations", ["takencourse_id", "courstudent_id"], :name => "index_courseregistrations_on_takencourse_id_and_courstudent_id", :unique => true
  add_index "courseregistrations", ["takencourse_id"], :name => "index_courseregistrations_on_takencourse_id"

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.decimal  "average_rating", :precision => 2, :scale => 1, :default => 0.0
    t.integer  "num_rating",                                   :default => 0
    t.integer  "rating_algo",                                  :default => 0
  end

  add_index "courses", ["rating_algo", "created_at"], :name => "index_courses_on_rating_algo_and_created_at"
  add_index "courses", ["user_id", "created_at"], :name => "index_courses_on_user_id_and_created_at"

  create_table "examresults", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exam_id"
    t.integer  "finalgrade"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "exams", :force => true do |t|
    t.integer  "course_id"
    t.text     "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "grade"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "course_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "filename"
    t.string   "contenttype"
  end

  add_index "notes", ["course_id", "created_at"], :name => "index_notes_on_course_id_and_created_at"

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "prerequisites", :force => true do |t|
    t.integer  "wantpro_id"
    t.integer  "want_id"
    t.integer  "required_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "prerequisites", ["required_id"], :name => "index_prerequisites_on_required_id"
  add_index "prerequisites", ["want_id", "wantpro_id", "required_id"], :name => "index_prerequisites_on_want_id_and_wantpro_id_and_required_id", :unique => true
  add_index "prerequisites", ["want_id"], :name => "index_prerequisites_on_want_id"
  add_index "prerequisites", ["wantpro_id"], :name => "index_prerequisites_on_wantpro_id"

  create_table "programratings", :force => true do |t|
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "program_id"
    t.text     "review_content"
    t.string   "review_title"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "programratings", ["user_id", "program_id"], :name => "index_programratings_on_user_id_and_program_id", :unique => true

  create_table "programs", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.decimal  "average_rating", :precision => 2, :scale => 1, :default => 0.0
    t.integer  "num_rating",                                   :default => 0
    t.integer  "rating_algo",                                  :default => 0
  end

  add_index "programs", ["rating_algo", "created_at"], :name => "index_programs_on_rating_algo_and_created_at"
  add_index "programs", ["user_id", "created_at"], :name => "index_programs_on_user_id_and_created_at"

  create_table "questions", :force => true do |t|
    t.integer  "exam_id"
    t.text     "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "registrations", :force => true do |t|
    t.integer  "student_id"
    t.integer  "takenprog_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "registrations", ["student_id"], :name => "index_registrations_on_student_id"
  add_index "registrations", ["takenprog_id", "student_id"], :name => "index_registrations_on_takenprog_id_and_student_id", :unique => true
  add_index "registrations", ["takenprog_id"], :name => "index_registrations_on_takenprog_id"

  create_table "relationships", :force => true do |t|
    t.integer  "course_id"
    t.integer  "program_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "relationships", ["course_id"], :name => "index_relationships_on_course_id"
  add_index "relationships", ["program_id", "course_id"], :name => "index_relationships_on_program_id_and_course_id", :unique => true
  add_index "relationships", ["program_id"], :name => "index_relationships_on_program_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.boolean  "creator",         :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
