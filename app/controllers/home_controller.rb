require 'net/http'
require 'json'

require './app/helpers/home_helper.rb'
require './db/CourseTable.rb'

class HomeController < ApplicationController
	include HomeHelper
  def search
    # @product = User.page(params[:page]).per(5)

    #@product = User.order(:email).page params[:page]
    #User.reindex
    @result=execute_statement("select email from users")
    @product = User.search "vg", page: params[:active], per_page: 1
    #byebug
     @chart_values = '['
    @product.each do |m|

     @chart_values = @chart_values+"\"#{m.email}\""+','
    end
    @chart_values = @chart_values+']'

   # products = User.search "vg"
    #products.each do |product|
    #@product=product.active
    #end
	end
  def catalog
  	p = PostgresDirect.new()
  	p.connect
  	
    p.createUserTable("catalog")
    p.prepareInsertUserStatement("catalog")

    for course_site in HomeHelper::MOOCS
    	HomeHelper.add_courses_to_db(course_site, p)
	 end
   @product = User.page(params[:page]).per(25)
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
