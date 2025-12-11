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

ActiveRecord::Schema[8.0].define(version: 2024_12_10_000005) do
  create_table "diagram_elements", force: :cascade do |t|
    t.bigint "diagram_id", null: false
    t.string "element_type", null: false
    t.string "uml_store_element_id"
    t.json "position", default: {"x" => 0, "y" => 0}, null: false
    t.json "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagram_id"], name: "index_diagram_elements_on_diagram_id"
    t.index ["element_type"], name: "index_diagram_elements_on_element_type"
    t.index ["uml_store_element_id"], name: "index_diagram_elements_on_uml_store_element_id"
  end

  create_table "diagram_relationships", force: :cascade do |t|
    t.bigint "diagram_id", null: false
    t.bigint "source_element_id", null: false
    t.bigint "target_element_id", null: false
    t.string "relationship_type", null: false
    t.json "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagram_id"], name: "index_diagram_relationships_on_diagram_id"
    t.index ["relationship_type"], name: "index_diagram_relationships_on_relationship_type"
    t.index ["source_element_id", "target_element_id"], name: "index_relationships_on_source_and_target"
    t.index ["source_element_id"], name: "index_diagram_relationships_on_source_element_id"
    t.index ["target_element_id"], name: "index_diagram_relationships_on_target_element_id"
  end

  create_table "diagrams", force: :cascade do |t|
    t.string "name", null: false
    t.string "diagram_type", null: false
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.string "uml_store_id"
    t.json "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagram_type"], name: "index_diagrams_on_diagram_type"
    t.index ["project_id"], name: "index_diagrams_on_project_id"
    t.index ["uml_store_id"], name: "index_diagrams_on_uml_store_id"
    t.index ["updated_at"], name: "index_diagrams_on_updated_at"
    t.index ["user_id"], name: "index_diagrams_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["updated_at"], name: "index_projects_on_updated_at"
    t.index ["user_id", "status"], name: "index_projects_on_user_id_and_status"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "role", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "diagram_elements", "diagrams"
  add_foreign_key "diagram_relationships", "diagram_elements", column: "source_element_id"
  add_foreign_key "diagram_relationships", "diagram_elements", column: "target_element_id"
  add_foreign_key "diagram_relationships", "diagrams"
  add_foreign_key "diagrams", "projects"
  add_foreign_key "diagrams", "users"
  add_foreign_key "projects", "users"
end
