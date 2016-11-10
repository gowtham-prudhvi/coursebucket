create_table "user_courses", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.string  "course_id",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# reference http://www.thecodeknight.com/post_categories/search/posts/recommendations_with_solr
  class Catalog < ActiveRecord::Base
  searchable do
    integer :played_for, using: :user_tastes, multiple: true
  end
end

def most_similar_users
  similar_users = Song.search do
    with(:id, my_tastes)
    facet(:played_for)
  end

  similar_users.facet(:played_for).rows[0...COUNT].map do |f|
    {user_id: f.value, similarity: f.count}
  end
end


Song.search do
  adjust_solr_params do |params|
    params[:q] = similarity_query(similar_users)
  end
end

def similarity_query(similar_users)
  similar_users.map{|k| "#{k[:user_id]}^#{k[:similarity]}"}.join(" OR ")
  "played_for_im:(#{users})"
end