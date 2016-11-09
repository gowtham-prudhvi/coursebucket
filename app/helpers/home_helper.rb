require 'net/http'
require 'json'

module HomeHelper
	MOOCS = Array.[]("coursera","udacity")

	COURSERA = "coursera"
	UDACITY = "udacity"

	UDACITY_URL = "https://www.udacity.com/public-api/v0/courses"
	COURSERA_URL = "https://api.coursera.org/api/courses.v1?start=%d&limit=25"
	COURSERA_COURSE_DETAILS_URL = "https://api.coursera.org/api/courses.v1/%s?includes=instructorIds,partnerIds&fields=instructorIds,previewLink,partnerIds,photoUrl,instructors.v1(firstName,lastName,suffix)"

	def self.add_courses_to_db(course_site, connection)
	  	i = 0
	    nxt = 1
	    while nxt > 0 do
	    	course_url = get_url(course_site, i)
	    	puts "i=#{i}"
	    	puts "#{course_url}"
		  	course_uri = URI(course_url)
		  	course_response = Net::HTTP.get(course_uri)
		  	course_json = JSON.parse(course_response)
		  	course_courses = get_courses(course_json)
		  	
		  	# puts "#{course_courses}"
		  	for course in course_courses
			  	course_id = get_course_id(course)
			  	name = get_name(course)
			  	slug = get_slug(course)

			  	if course_site == COURSERA
			  		# Coursera - get course details here
			  		instructors = get_instructors(COURSERA, course_id)
			  		partners,homepage = get_details(COURSERA, course_id)
			  	elsif course_site == UDACITY
			  		# Udacity - course details
			  		instructors = get_instructors(UDACITY,0,course)
			  		partners,homepage = get_details(UDACITY, 0, course)
			  	end
			  	puts "------instructors=<#{instructors}>-----"
			  	puts "------partners=<#{partners}>---"
			  	puts "----homepage=<#{homepage}>---"
			  	connection.addUser(course_id, name, slug, course_site, instructors, partners, homepage, 0)
		  	end

		  	i += 25
		  	if course_site == COURSERA
		  		if course_json["paging"].key?("next")
		  			nxt = course_json["paging"]["next"].to_i
		  		else
		  			nxt = 0
		  		end
		  	else
		  		nxt = 0
		  	end
	    end
  	end

	def self.get_courses(json_data)
		if json_data.key?("elements")
			return json_data["elements"]
		elsif json_data.key?("courses")
			return json_data["courses"]
		end
	end

	def self.get_url(course_site, index)
		if course_site == COURSERA
			return COURSERA_URL % [index]
		elsif course_site == UDACITY
			return UDACITY_URL
		end
	end

	def self.get_course_id(dicti)
		if dicti.key?("id")
			return dicti["id"]                  
		elsif dicti.key?("key")
			return dicti["key"]
		else
			return "No course_id"
		end
	end

	def self.get_name(dicti)
		if dicti.key?("name")
			return dicti["name"]
		elsif dicti.key?("title")
			return dicti["title"]
		else
			return "No name"
		end

	end

	def self.get_slug(dicti)
		if dicti.key?("slug")
			return dicti["slug"]
		else
			return "No slug"
		end
	end
   ################### Photo URl 
	def self.get_photo(site, id=0, course={})
		photo_url=""
		if site == UDACITY
			if course.key?("image")
				photo_url = course["image"]
			end	

		elsif site == COURSERA
			details_url = COURSERA_COURSE_DETAILS_URL % [id]
			uri = URI(details_url)
			response = Net::HTTP.get(uri)
		  	json = JSON.parse(response)
		  	details = json["elements"] 
			if json["elements"][0].key?("photoUrl")
				puts json["elements"][0]["photoUrl"]
				photo_url= "json['elements'][0]['photoUrl']"
			end	
		end	
		return photo_url
	end	

	def self.get_details(site, id=0, course={})
		partners = "None"
		course_url=""
		if site== UDACITY
			################ Course URL udacity
			if course.key?("homepage")
				course_url=course["homepage"]
			end
			################ Affiliates or partners udacity
			partners_array = course["affiliates"]
			num = partners_array.length
			if num == 0 
				partners = "None"
			else
				temp = 0
				if !(partners_array[temp].nil?) and partners_array[temp].key?("name")
					partners = "#{partners_array[temp]['name']}"
				end
				while temp + 1 < num
					temp += 1
					if !(partners_array[temp].nil?) and partners_array[temp].key?("name")
						partners += ",#{partners_array[temp]['name']}"
					end
				end
			end		
		elsif site == COURSERA
			details_url = COURSERA_COURSE_DETAILS_URL % [id]
			uri = URI(details_url)
			response = Net::HTTP.get(uri)
		  	json = JSON.parse(response)
		  	details = json["linked"]
			################## Course URL coursera
			if json["elements"][0].key?("slug")
				puts json["elements"][0]["slug"]
				course_url="https://www.coursera.org/learn/#{json['elements'][0]['slug']}"
			end
		  	################## Partners Coursera
		  	if details.key?("partners.v1")
		  		partners_array = details["partners.v1"]
		  		num = partners_array.length
		  		if num == 0
		  			partners = "None"
		  		else
		  			temp = 0
		  			if !(partners_array[temp].nil?) and partners_array[temp].key?("name")
		  				partners = "#{partners_array[temp]['name']}" 
		  			end
		  			while temp + 1 < num
		  				temp += 1
		  				if !(partners_array[temp].nil?) and partners_array[temp].key?("name")
		  					partners += ",#{partners_array[temp]['name']}" 
		  				end
		  			end
		  		end 
		  	else
		  		partners = "None"
		  	end
		end	

		return partners,course_url
	end	

	def self.get_instructors(site, id=0, course={})
		instructors = "None"
		if site == COURSERA
			details_url = COURSERA_COURSE_DETAILS_URL % [id]
			uri = URI(details_url)
			response = Net::HTTP.get(uri)
		  	json = JSON.parse(response)
		  	details = json["linked"]
		  	if details.key?("instructors.v1")
		  		# instructor
		  		instructors_array = details["instructors.v1"]
		  		puts instructors_array
		  		num = instructors_array.length
		  		if num == 0
		  			instructors = "None"
		  		else
		  			temp = 0
		  			if !(instructors_array[temp].nil?) and instructors_array[temp].key?("fullName")
		  				instructors = "#{instructors_array[temp]['fullName']}"	
		  			end
		  			while temp + 1 < num
		  				temp += 1
		  				if !(instructors_array[temp].nil?) and instructors_array[temp].key?("fullName")
		  					instructors += ",#{instructors_array[temp]['fullName']}"	
		  				end
		  			end
		  		end 
		  	else
		  		instructors = "None"
		  	end
		elsif site == UDACITY
			instructors_array = course["instructors"]
			num = instructors_array.length
			if num == 0
				instructors = "None"
			else
				temp = 0
				if !(instructors_array[temp].nil?) and instructors_array[temp].key?('name')
					instructors = "#{instructors_array[temp]['name']}"
				end
				while temp + 1 < num
					temp += 1
					if !(instructors_array[temp].nil?) and instructors_array[temp].key?('name')
						instructors += ",#{instructors_array[temp]['name']}"
					end
				end
			end
		end
		return instructors
	end

	def self.get_course_details(site, id)
		# TODO: search in the db according to id
	end
end