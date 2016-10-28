class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
 ActionMailer::Base.mail(from: "coursebucket123@gmail.com", to: "sughoshpatil@gmail.com", subject: "Test", body: "Test").deliver
end
