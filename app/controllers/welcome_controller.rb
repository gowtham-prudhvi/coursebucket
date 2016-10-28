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
      id=result[0]["id"]
      hash=result[0]["password"]
      cookies[:user_id] = { :value => id, :expires => Time.now + 10800}
      cookies[:hash] = { :value => hash, :expires => Time.now + 10800}
      redirect_to "/welcome/index"
    else
      @controller_message="Incorrect password or email"

    end
  	end  	
     
  end 
  def signup
    #ActionMailer::Base.mail(from: "coursebucket123@gmail.com", to: "v.g.prudhvi38@gmail.com", subject: "Test", body: "Test").deliver
   # SignupMailer::welcome_email()
    #byebug
    if cookies[:user_id]
      result=execute_statement("select password from users where id=#{cookies[:user_id]}")

      if cookies[:hash].eql? result[0]["password"]
        redirect_to "/welcome/index"
        bell=0
        return
      end 
    end
    require 'digest/md5'
  	if params[:user]
  		email = params[:user][:email]
      first_name = params[:user][:first_name]
      last_name = params[:user][:last_name]
      if params[:user][:password].eql? params[:user][:password_confirmation]
      password_hash=Digest::MD5.hexdigest(params[:user][:password])
  		exec=execute_statement("insert into users(email,password,first_name,last_name) values('#{email}','#{password_hash}','#{first_name}','#{last_name}')")
      @controller_message="successfully signedup login now"
      else
        @controller_message="both passwords are different signup again"
      end
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
