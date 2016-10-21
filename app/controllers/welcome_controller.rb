class WelcomeController < ApplicationController
  def index
  end
  def login
  	if params[:user]
  	@posts = params[:user][:password]
  	end  	
     
  end
  def signup
  	if params[:user]
  		@email = params[:user][:email]
  		@exec=execute_statement("insert into users values(1,'vg','vg','vg','vg')")
  		@exec=execute_statement("select * from users")
  		print @exec

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
