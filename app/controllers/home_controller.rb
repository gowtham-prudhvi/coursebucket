require 'net/http'
require 'json'

require './app/helpers/home_helper.rb'
#require './db/CourseTable.rb'

class HomeController < ApplicationController
  before_action :authenticate_deviseuser!
	include HomeHelper
  def search
    if params[:tags]

      #when searched in home search
curr_search_field=params[:tags]
#@result=execute_statement("select search_field from catalog order by updated_at limit 10")
  id=current_deviseuser["id"]
  execute_statement("insert into user_recent_search(user_id,search_field) values(#{id},'#{curr_search_field}')")
  #update field of update last one
  #we will leave this for now will store all searches of user
    @product =Catalog.search do
      any do
      fulltext(params[:tags])
      end
      order_by(:score, :desc)
      paginate(:page => params[:page] || 1, :per_page => 10)
    end


    @product1=@product
    @product=@product.results

    @result=execute_statement("select name from catalog")
    @chart_values = '['
    @result.each do |m|
      value=m["name"].downcase.gsub(/[^a-z0-9\s]/i, '')
      @chart_values = @chart_values+"\"#{value}\""+','
    end
    @chart_values = @chart_values+']'


    else
      id=current_deviseuser["id"]   
      @result=execute_statement("select search_field from user_recent_search where user_id=#{id} ORDER BY id DESC LIMIT 10")
       @recommend =Catalog.search do
       any do
      # fulltext("machine")
        if @result.nfields ==1     
        fulltext(@result[0]["search_field"])
        end
    #   # @result.each do |product|
        end
    #   end
       order_by(:score, :desc)
      # paginate(:page => params[:page] || 1, :per_page => 10)
     end
      byebug
      @product =Catalog.search do
      keywords('asaasss')
      paginate(:page => params[:page] || 1, :per_page => 10)
      end


    @product1=@product
    @product=@product.results


    @result=execute_statement("select name from catalog")
    @chart_values = '['
    @result.each do |m|
      value=m["name"].downcase.gsub(/[^a-z0-9\s]/i, '')
      @chart_values = @chart_values+"\"#{value}\""+','
    end
    @chart_values = @chart_values+']'
    end
	end
  
  def catalog
    byebug
   @product = Catalog.order('name').page(params[:page]).per(10)
  end

  def course_details
   @id = params[:id]
   @site=params[:site]
   # TODO:
   details = HomeHelper.get_course_details(site, id)
     
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
