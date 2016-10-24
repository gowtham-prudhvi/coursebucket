require 'net/http'
require 'json'
require 'db/CourseTable.rb'

class HomeController < ApplicationController
  def catalog
  	p = PostgresDirect.new()
  	p.connect
  	begin
	    p.createUserTable("catalog")
	    p.prepareInsertUserStatement("catalog")

	    i = 0
	    len = 1
	    while len > 0 do
	    	coursera_url = 'https://api.coursera.org/api/courses.v1?start=#{i}&limit=25'
		  	coursera_uri = URI(coursera_url)
		  	coursera_response = Net::HTTP.get(coursera_uri)
		  	coursera_json = JSON.parse(coursera_response)
		  	coursera_courses = coursera_json["elements"]
		  	
		  	# add each course to db
		  	for course in coursera_courses
			  	id = course["id"]
			  	name = course["name"]
			  	slug = course["slug"]
			  	courseType = course["courseType"] 
			  	p.addUser(id, name, slug, courseType)
		  	end

		  	len = coursera_courses.length
		  	i += 25
	    end
	end

  end
end
require '/home/kk/Dropbox/Acads/sem 5/CS252/coursebucket/db/CourseTable'
