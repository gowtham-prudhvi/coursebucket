require 'net/http'
require 'json'

require 'db/CourseTable.rb'
require 'app/helpers/home_helper.rb'

class HomeController < ApplicationController
  def catalog
  	p = PostgresDirect.new()
  	p.connect
  	
  	begin
	    p.createUserTable("catalog")
	    p.prepareInsertUserStatement("catalog")

	    for course_site in HomeHelper::MOOCS
	    	add_courses_to_db(course_site)
		end
	end
  end

  def add_courses_to_db(course_site)
  	i = 0
    nxt = 1
    while nxt > 0 do
    	course_url = HomeHelper.get_url(course_site, i)
	  	course_uri = URI(course_url)
	  	course_response = Net::HTTP.get(course_uri)
	  	course_json = JSON.parse(course_response)
	  	course_courses = HomeHelper.get_courses(course_json)
	  	
	  	# add each course to db
	  	for course in course_courses
		  	id = HomeHelper.get_id(course)
		  	name = HomeHelper.get_name(course)
		  	slug = HomeHelper.get_slug(course)
		  	p.addUser(id, name, slug, course_site)
	  	end

	  	i += 25
	  	if course_site == "coursera"
	  		nxt = course_json["next"]
	  	else
	  		nxt = 0
	  	end
    end
  end


end
