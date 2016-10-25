module HomeHelper
	MOOCS = {"coursera", "udacity"}

	def get_courses(json_data)
		if json_data.key?(:elements)
			return json_data["elements"]
		elsif json_data.key?(:courses)
			return json_data["courses"]
		end

	def get_url(course_site, index)
		if course_site == "coursera"
			return "https://api.coursera.org/api/courses.v1?start=#{index}&limit=25"
		elsif course_site == "udacity"
			return "https://www.udacity.com/public-api/v0/courses"
		end
	end

	def get_id(dicti)
		if dicti.key?(:id)
			return dicti["id"]
		elsif dicti.key?(:key)
			return dicti["key"]
		else
			return "No id"
		end
	end

	def get_name(dicti)
		if dicti.key?(:name)
			return dicti["name"]
		elsif dicti.key?(:title)
			return dicti["title"]
		else
			return "No name"
		end
	end

	def get_slug(dicti)
		if dicti.key?(:slug)
			return dicti("slug")
		else
			return "No slug"
		end
	end
end
