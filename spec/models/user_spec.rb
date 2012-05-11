require 'spec_helper'

describe User do   
  context 'user is not create' do   
    describe 'User#create_with_omniauth' do    
      it { User.count.should == 0 } 

      context 'add data' do 
        before(:all) do 
          @user = Hash.new
          @user['uid'] = '000000'
          @user['provider'] = 'twitter'
          @user['info'] = Hash.new 
          @user['info']['nickname'] = 'test' 
          User.create_with_omniauth(@user)  
        end

        it 'increment user data' do    
          User.count.should == 1   
        end  

        it 'search from provider' do     
          User.where(:provider => 'twitter').count.should == 1
        end 

        it 'search from name' do     
          User.where(:name=> 'test').count.should == 1
        end 

        it 'search from uid' do     
          User.where(:uid=> '000000').count.should == 1
        end
      end  

    end 
  end 
end
