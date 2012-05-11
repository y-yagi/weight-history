require 'spec_helper'    
require 'webmock/rspec'

def stub_get(path, endpoint=Twitter.endpoint)
end   

def stub_directmessages(text = 'text')
  WebMock.stub_request(:get, Twitter.endpoint + '/1/direct_messages.json').
    to_return(:body => direct_message_body(text), :headers => {:content_type => 'application/json; charset=utf-8'}) 
end  
def stub_destory_directmessage
  WebMock.stub_request(:delete, Twitter.endpoint + "/1/direct_messages/destroy/200817204063780864.json").
    to_return(:body => direct_message_body, :headers => {:content_type => "application/json; charset=utf-8"}) 
end


def direct_message_body(text = 'text') 
return <<EOS   
[{"sender_screen_name":"weighthistor","sender":{"id":552470147,"id_str":"552470147","default_profile":true,"profile_use_background_image":true,"location":null,"profile_text_color":"333333","statuses_count":1,"following":false,"utc_offset":32400,"profile_sidebar_border_color":"C0DEED","listed_count":0,"name":"weight-history","protected":true,"profile_background_tile":false,"is_translator":false,"profile_sidebar_fill_color":"DDEEF6","contributors_enabled":false,"profile_image_url_https":"https://si0.twimg.com/sticky/default_profile_images/default_profile_5_normal.png","geo_enabled":false,"friends_count":1,"description":null,"profile_background_image_url_https":"https://si0.twimg.com/images/themes/theme1/bg.png","default_profile_image":true,"notifications":false,"profile_image_url":"http://a0.twimg.com/sticky/default_profile_images/default_profile_5_normal.png","show_all_inline_media":false,"favourites_count":0,"followers_count":1,"follow_request_sent":false,"profile_background_color":"C0DEED","url":null,"screen_name":"weighthistory","verified":false,"lang":"ja","created_at":"Fri Apr 13 06:21:24 +0000 2012","profile_background_image_url":"http://a0.twimg.com/images/themes/theme1/bg.png","profile_link_color":"0084B4","time_zone":"Irkutsk"},"id_str":"200817204063780864","created_at":"Fri May 11 05:18:47 +0000 2012","recipient_screen_name":"weighthistory","recipient_id":552470147,"sender_id":552470147,"recipient":{"id":552470147,"id_str":"552470147","default_profile":true,"profile_use_background_image":true,"location":null,"profile_text_color":"333333","statuses_count":1,"following":false,"utc_offset":32400,"profile_sidebar_border_color":"C0DEED","listed_count":0,"name":"weight-history","protected":true,"profile_background_tile":false,"is_translator":false,"profile_sidebar_fill_color":"DDEEF6","contributors_enabled":false,"profile_image_url_https":"https://si0.twimg.com/sticky/default_profile_images/default_profile_5_normal.png","geo_enabled":false,"friends_count":1,"description":null,"profile_background_image_url_https":"https://si0.twimg.com/images/themes/theme1/bg.png","default_profile_image":true,"notifications":false,"profile_image_url":"http://a0.twimg.com/sticky/default_profile_images/default_profile_5_normal.png","show_all_inline_media":false,"favourites_count":0,"followers_count":1,"follow_request_sent":false,"profile_background_color":"C0DEED","url":null,"screen_name":"weighthistory","verified":false,"lang":"ja","created_at":"Fri Apr 13 06:21:24 +0000 2012","profile_background_image_url":"http://a0.twimg.com/images/themes/theme1/bg.png","profile_link_color":"0084B4","time_zone":"Irkutsk"},"id":200817204063780864,"text":"#{text}"}]
EOS
end 

describe DirectMessage do     
  before(:all)  do  
    Twitter.configure do |config|
      config.consumer_key = WeightHistory::Application.config.t_key
      config.consumer_secret = WeightHistory::Application.config.t_secret
      config.oauth_token = WeightHistory::Application.config.t_wh_oauth_token
      config.oauth_token_secret = WeightHistory::Application.config.t_wh_oauth_token_secret 
    end   
  end     

  context 'no data' do   
    before do 
      stub_destory_directmessage
    end 

    after do 
      WeightData.delete_all  
    end 

    describe 'DirectMessage.exec' do   
      it 'with no DM' do 
        stub_directmessages
        DirectMessage.exec
        WeightData.count.should == 0
      end  

      it 'with weight DM' do 
        message = 'w:60.0' 
        stub_directmessages(message)
        DirectMessage.exec
        WeightData.count.should == 1    
        WeightData.where(:weight => 60.0).count.should == 1
      end 

      it 'with body fat percentage DM' do 
        message = 'bfp:17.0'
        stub_directmessages(message)
        DirectMessage.exec
        WeightData.count.should == 1    
        WeightData.where(:body_fat_percentage => 17.0).count.should == 1
      end 

      it 'with body fat percentage and weight DM' do 
        message = 'w:59.0 bfp:18.5'
        stub_directmessages(message)
        DirectMessage.exec
        WeightData.count.should == 1    
        WeightData.where(:body_fat_percentage => 18.5).count.should == 1
        WeightData.where(:weight => 59.0).count.should == 1
      end   

      it 'with error format DM' do 
        message = 'w-59.0 bfp;18.5'
        stub_directmessages(message)
        DirectMessage.exec
        WeightData.count.should == 0
      end 
    end    
  end 
  
  
  context 'exist data' do 
    before do
      message = 'w:59.0 bfp:18.5'
      stub_directmessages(message)
      stub_destory_directmessage
      DirectMessage.exec
    end  

    after do 
      WeightData.delete_all  
    end  

    describe 'DirectMessage.exec' do    
      it 'update weight only' do
        message = 'w:59.2'
        stub_directmessages(message)
        DirectMessage.exec
        WeightData.count.should == 1    
        WeightData.where(:body_fat_percentage => 18.5).count.should == 1
        WeightData.where(:weight => 59.2).count.should == 1
      end 

      it 'update body fat percentage only' do
        message = 'bfp:17.9'
        stub_directmessages(message)
        DirectMessage.exec
        WeightData.count.should == 1    
        WeightData.where(:body_fat_percentage => 17.9).count.should == 1
        WeightData.where(:weight => 59.0).count.should == 1
      end
  
      it 'update body fat percentage and weight' do 
        message = 'w:58.3 bfp:17.3'
        stub_directmessages(message)
        DirectMessage.exec
        WeightData.count.should == 1    
        WeightData.where(:body_fat_percentage => 17.3).count.should == 1
        WeightData.where(:weight => 58.3).count.should == 1
      end 
    end  
  end   
end
