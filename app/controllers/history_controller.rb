class HistoryController < ApplicationController
  def index
    redirect_to root_url unless logged_in?
  end  
 
  respond_to :json
  def data  
    return nil unless logged_in?      
    weight_data = WeightData.where(:uid => session[:uid]).order(:data_date)  
    respond_with(weight_data) do |format|   
      data = Hash.new 
      data[:weight] = weight_data.map{|data| [data.data_date.to_time.to_i * 1000, data.weight]}     
      data[:body_fat_percentage] = weight_data.map{|data| [data.data_date.to_time.to_i * 1000, data.body_fat_percentage]}     
      format.json { render :json => data}
    end
  end 
end
