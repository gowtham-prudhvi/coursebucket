require 'net/http'
require 'json'

require './app/helpers/home_helper.rb'
require './db/CourseTable.rb'

class HomeController < ApplicationController
  before_action :authenticate_deviseuser!
	include HomeHelper
  def search
    if params[:tags]

      #when searched in home search
     curr_search_field=params[:tags]
    # id=current_deviseuser["id"]   
    # @recommend =Catalog.search do
    # any do
    #   fulltext("asaaasfsfddfsfds")
    # end
        
    # order_by(:score, :desc)
    # end
    # @recommend=@recommend.results


    id=current_deviseuser["id"]
    object = UserRecentSearch.new(:user_id => id, :search_field => curr_search_field)
    object.save
    # byebug
    # execute_statement("insert into user_recent_search(user_id,search_field) values(#{id},'#{curr_search_field}')")
    @product =Catalog.search do
      fulltext(params[:tags])
      # order_by(:score, :asc)
      paginate(:page => params[:page] || 1, :per_page => 10)
    end


    @product1=@product
    @product=@product.results

    @result=  Catalog.order('name')
    @chart_values = '['
    @result.each do |m|
      value=m["name"].downcase.gsub(/[^a-z0-9\s]/i, '')
      @chart_values = @chart_values+"\"#{value}\""+','
    end
    @chart_values = @chart_values+']'


    else
      id=current_deviseuser["id"]   
      @result=UserRecentSearch.select(:search_field).where(UserRecentSearch.arel_table[:user_id].eq(id)).order(:user_id).reverse_order.limit(5)
      # byebug

      first=@result[0]["search_field"]
      second=@result[1]["search_field"]
      third=@result[2]["search_field"]
      fourth=@result[3]["search_field"]
      fifth=@result[4]["search_field"]
      @recommend =Catalog.search do
       any do
        fulltext(first)
        fulltext(second)
        fulltext(third)
        fulltext(fourth)
        fulltext(fifth)
        end
        
       order_by(:score, :desc)
     end
     @recommend=@recommend.results
      # byebug
    #   @product =Catalog.search do
    #   keywords('asaasss')
    #   paginate(:page => params[:page] || 1, :per_page => 10)
    #   end


    # @product1=@product
    # @product=@product.results

    # byebug
    @result=Catalog.order('name')
    @chart_values = '['
    @result.each do |m|
      value=m["name"].downcase.gsub(/[^a-z0-9\s]/i, '')
      @chart_values = @chart_values+"\"#{value}\""+','
    end
    @chart_values = @chart_values+']'
    end
	end
  
  def catalog
    priority = params[:priority]
    if !(priority == "counter DESC" or priority == "instructors" or priority == "organization") 
      priority = "name"
    end
    @product = Catalog.order(priority).page(params[:page]).per(10)
  end

  def course_details
   @url = params[:url]
   @id = params[:id]
   @counter = params[:counter].to_i
   @counter+=1
   # execute_statement("update catalog  set counter=#{@counter} where id=#{@id}")
   course = Catalog.find_by(id: @id)
   course.update(counter: @counter)

   redirect_to @url
  end
  
  def catalog_update
    p = PostgresDirect.new()
    p.connect
    
    p.createUserTable("catalog")
    p.prepareInsertUserStatement("catalog")

    for course_site in HomeHelper::MOOCS
      HomeHelper.add_courses_to_db(course_site, p)
   end
  end
  
  def execute_statement(sql)
        results = ActiveRecord::Base.connection.execute(sql)
        if results.present?
            return results
        else
            return nil
        end
    end

end
