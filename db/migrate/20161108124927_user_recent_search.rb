class UserRecentSearch < ActiveRecord::Migration[5.0]
  def change
  	create_table "user_recent_search", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.string  "search_field",        null: false
  end
  end
end
