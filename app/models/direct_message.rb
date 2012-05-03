class DirectMessage  
  def self.exec 
    init  
    Twitter.direct_messages.each do |dm| 
      create_or_update(dm)
      delete(dm)
    end 
  end  

  private  
  def self.init 
    Twitter.configure do |config|
      config.consumer_key = WeightHistory::Application.config.t_key
      config.consumer_secret = WeightHistory::Application.config.t_secret
      config.oauth_token = WeightHistory::Application.config.t_wh_oauth_token
      config.oauth_token_secret = WeightHistory::Application.config.t_wh_oauth_token_secret
    end   
  end  

  def self.create_or_update(dm) 
    weight,body_fat_percentage = nil 
    weight = $1 if dm.text=~ /w:([0-9]+\.[0-9]+)/
    body_fat_percentage = $1 if dm.text=~ /bfp:([0-9]+\.[0-9]+)/
    if weight || body_fat_percentage
      wd = WeightData.where(:uid => dm.sender.id.to_s, :data_date => dm.created_at).first
      if wd   
        # update      
        wd.weight = weight if weight 
        wd.body_fat_percentage = body_fat_percentage if body_fat_percentage  
        wd.save 
      else 
        # create   
        WeightData.create(
          :uid => dm.sender.id.to_s, 
          :data_date => dm.created_at,
          :weight => weight,
          :body_fat_percentage => body_fat_percentage
        )     
      end
    end 
  end

  def self.delete (dm)
    Twitter.direct_message_destroy(dm.id) 
  end 
end 
