class SessionsController < ApplicationController 
  def callback
    auth = request.env["omniauth.auth"] 

    user = User.find_by_provider_and_uid(auth["provider"],
            auth["uid"]) || User.create_with_omniauth(auth)

    session[:uid] = user.uid
    session[:name] = user.name
    redirect_to '/history'
  end  

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "logout" 
  end 
end
