class HistoryController < ApplicationController
  def index
    redirect_to root_url if logged_in?
  end  

  def data
    return nil if logged_in?  
    weight_data = WeightData.where(:name => session[:name]).order("created_at") 
    weight_data.to_json
  end 
end
