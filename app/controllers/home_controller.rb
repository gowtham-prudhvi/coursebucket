require 'net/http'
require 'json'

require '/home/kk/Dropbox/Acads/sem 5/CS252/coursebucket/app/helpers/home_helper.rb'
require '/home/kk/Dropbox/Acads/sem 5/CS252/coursebucket/db/CourseTable.rb'

class HomeController < ApplicationController
	include HomeHelper
  def search
     @product = User.page(params[:page]).per(5)

    #@product = User.order(:email).page params[:page]
    #User.reindex
    #@product = User.search "vg", page: params[:active], per_page: 1
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
  
end
