
#for schema
create_table "user_recent_search", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.string  "search_field",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
#when searched in home search
curr_search_field=params[:tags]
@result=execute_statement("select search_field from catalog order by updated_at")
num_rows=
if num_rows<10 
	execute_statement("insert into user_recent_search(user_id,search_field) values(#{id},#{curr_search_field})")
else
	#update field of update last one
end
#recommendation
id=getUserid()
 @result=execute_statement("select search_field from user_recent_search where user_id=#{id}")
@product =Catalog.search do
      any do
      @result.each do |product|
      fulltext(product["search_field"])
      end
      paginate(:page => params[:page] || 1, :per_page => 10)
    end


    @product1=@product
    @product=@product.results
