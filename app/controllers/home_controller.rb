require 'net/http'
require 'json'

class HomeController < ApplicationController
  def catalog
  	coursera_url = 'https://api.coursera.org/api/courses.v1?start=0&limit=25'
  	coursera_uri = URI(courses_url)
  	coursera_response = Net::HTTP.get(courses_uri)
  	coursera_json = JSON.parse(courses_response)

  end
end
