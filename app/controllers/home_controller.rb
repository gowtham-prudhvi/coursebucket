require 'net/http'
require 'json'

require './app/helpers/home_helper.rb'
require './db/CourseTable.rb'

class HomeController < ApplicationController
	include HomeHelper
  def search
    # @product = User.page(params[:page]).per(5)
    if params[:tags]
      
    
    #@product = User.order(:email).page params[:page]
    #Catalog.reindex
    Catalog.reindex
    @result=execute_statement("select name from catalog")
    #@product = Catalog.search "machine", page: params[:active], per_page: 10
    @product = Catalog.search params[:tags], page: params[:active], per_page: 10
    #byebug
     @chart_values = '['
    @result.each do |m|
      value=m["name"].downcase.gsub(/[^a-z0-9\s]/i, '')
     @chart_values = @chart_values+"\"#{value}\""+','
    end
    @chart_values = @chart_values+']'
    else
       #User.reindex
    @result=execute_statement("select name from catalog")
    #@product = Catalog.search "machine", page: params[:active], per_page: 10
    @product = User.search "asa", page: params[:active], per_page: 10
    #byebug
     @chart_values = '['
    @result.each do |m|
      value=m["name"].downcase.gsub(/[^a-z0-9\s]/i, '')
     @chart_values = @chart_values+"\"#{value}\""+','
    end
    @chart_values = @chart_values+']'
    end

   # products = User.search "vg"
    #products.each do |product|
    #@product=product.active
    #end
	end
  
  def catalog
   @product = Catalog.order('name').page(params[:page]).per(10)
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
