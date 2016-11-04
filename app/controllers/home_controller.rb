require 'net/http'
require 'json'

require './app/helpers/home_helper.rb'
require './db/CourseTable.rb'

class HomeController < ApplicationController
	include HomeHelper
  def search
    
    if params[:tags]
    @product =Catalog.search do
      fulltext(params[:tags])
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
