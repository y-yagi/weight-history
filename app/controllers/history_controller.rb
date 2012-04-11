class HistoryController < ApplicationController
  def index
    redirect_to root_url unless logged_in?
  end  
 
  respond_to :json
  def data 
    return nil unless logged_in?      
    weight_data = WeightData.where(:name => session[:name]).order("created_at")  
    respond_with(weight_data) do |format|
      #format.json { render :json => weight_data.to_json(:only=>[:weight, :created_at])}     
      #data = weight_data.map{|data| [data.weight, data.created_at.strftime('%Y/%m/%d')]}   
      #data = weight_data.map{|data| [data.created_at.strftime('%Y-%m-%d'), data.weight]}   
      data = weight_data.map{|data| [data.created_at.to_i * 1000, data.weight]}   
      format.json { render :json => data}
    end
  end 
end
