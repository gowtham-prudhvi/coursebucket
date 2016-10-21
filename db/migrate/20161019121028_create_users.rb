class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    	t.string "email", :limit => 50, :null => false
      	t.column "password", :string, :null => false
      	t.column "first_name", :string,:limit => 30, :null => false
      	t.column "last_name", :string,:limit => 30, :null => false

      t.timestamps
    end
  end
end
