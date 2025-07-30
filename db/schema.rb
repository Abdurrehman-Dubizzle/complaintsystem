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

ActiveRecord::Schema[8.0].define(version: 2025_07_25_074929) do
  create_table "complain_messages", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.integer "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_id"], name: "index_complain_messages_on_complaint_id"
    t.index ["user_id"], name: "index_complain_messages_on_user_id"
  end

  create_table "complaint_stages", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.integer "stage_id", null: false
    t.boolean "completed"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reviewer_id"
    t.boolean "reviewer_approved"
    t.text "forwarded_decision"
    t.index ["complaint_id"], name: "index_complaint_stages_on_complaint_id"
    t.index ["stage_id"], name: "index_complaint_stages_on_stage_id"
  end

  create_table "complaints", force: :cascade do |t|
    t.string "category_type", default: "ambigious", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "stage_questions", force: :cascade do |t|
    t.integer "stage_id", null: false
    t.string "question_text"
    t.string "question_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_stage_questions_on_stage_id"
  end

  create_table "stage_responses", force: :cascade do |t|
    t.integer "complaint_stage_id", null: false
    t.integer "stage_question_id", null: false
    t.integer "user_id", null: false
    t.text "answer_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_stage_id"], name: "index_stage_responses_on_complaint_stage_id"
    t.index ["stage_question_id"], name: "index_stage_responses_on_stage_question_id"
    t.index ["user_id"], name: "index_stage_responses_on_user_id"
  end

  create_table "stage_templates", force: :cascade do |t|
    t.string "category_type"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stages", force: :cascade do |t|
    t.integer "stage_template_id", null: false
    t.string "title"
    t.integer "order"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_template_id"], name: "index_stages_on_stage_template_id"
  end

  create_table "user_complaints", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "complaint_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["complaint_id"], name: "index_user_complaints_on_complaint_id"
    t.index ["user_id"], name: "index_user_complaints_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "designation"
    t.string "ancestry"
    t.integer "report_to_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "complain_messages", "complaints"
  add_foreign_key "complain_messages", "users"
  add_foreign_key "complaint_stages", "complaints"
  add_foreign_key "complaint_stages", "stages"
  add_foreign_key "stage_questions", "stages"
  add_foreign_key "stage_responses", "complaint_stages"
  add_foreign_key "stage_responses", "stage_questions"
  add_foreign_key "stage_responses", "users"
  add_foreign_key "stages", "stage_templates"
  add_foreign_key "user_complaints", "complaints"
  add_foreign_key "user_complaints", "users"
end
