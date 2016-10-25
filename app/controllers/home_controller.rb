require 'net/http'
require 'json'

require 'db/CourseTable.rb'
require 'app/helpers/home_helper.rb'

class HomeController < ApplicationController
  def catalog
  	p = PostgresDirect.new()
  	p.connect
  	
    p.createUserTable("catalog")
    p.prepareInsertUserStatement("catalog")

    for course_site in HomeHelper::MOOCS
    	HomeHelper.add_courses_to_db(course_site, p)
	end
  end
  
end
