class WelcomeController < ApplicationController
  def index
  end
  def login
    require 'digest/md5'
  	if params[:user]
  	email = params[:user][:email]
    password_hash=Digest::MD5.hexdigest(params[:user][:password])
    result=execute_statement("select * from users where email='#{email}'")
    if password_hash.eql? result[0]["password"]
      @controller_message="successfully logged in"
    else
      @controller_message="Incorrect password or email"
    end
  	end  	
     
  end
  def signup
    require 'digest/md5'
  	if params[:user]
  		email = params[:user][:email]
      first_name = params[:user][:first_name]
      last_name = params[:user][:last_name]
      password_hash=Digest::MD5.hexdigest(params[:user][:password])
  		exec=execute_statement("insert into users(email,password,first_name,last_name) values('#{email}','#{password_hash}','#{first_name}','#{last_name}')")
      @controller_message="successfully signedup login now"

    else
      @controller_message="Enter the details and signup"
    end	
     
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
