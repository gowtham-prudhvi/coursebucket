class CreateUserRecentSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :user_recent_searches do |t|

      t.timestamps
    end
  end
end
