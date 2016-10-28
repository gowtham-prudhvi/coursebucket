class HomeController < ApplicationController
	require 'net/http'
	require 'json'
  def search
  	courses_url = 'https://api.coursera.org/api/courses.v1'
  	courses_uri = URI(courses_url)
  	courses_response = Net::HTTP.get(courses_uri)
  	courses_json = JSON.parse(courses_response)
  	#courses_json=courses_json["element"]
  	courses_json.each do |object|
  # This is a hash object so now create a new one.
  	#byebug
  	newMyObject = MyObject.new(object)
  	newMyObject.save # You can do validation or any other processing around here.
	end
  	 @q = Person.ransack(courses_json)
  	@people = @q.result(distinct: true)
  end
end
