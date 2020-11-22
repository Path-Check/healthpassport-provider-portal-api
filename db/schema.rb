# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 2020_11_21_015353) do
  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.string 'password_digest'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'private_key'
    t.string 'public_key'
  end

  create_table 'vaccination_programs', force: :cascade do |t|
    t.string 'vaccinator'
    t.string 'brand'
    t.string 'product'
    t.string 'lot'
    t.string 'dose'
    t.string 'route'
    t.string 'signature'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'user_id'
    t.index ['user_id'], name: 'index_vaccination_programs_on_user_id'
  end

  add_foreign_key 'vaccination_programs', 'users'
end
