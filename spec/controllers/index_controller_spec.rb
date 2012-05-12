require 'spec_helper'

describe IndexController do 

  describe 'GET index' do 
    context :html, :response do 
      subject { response } 
      it { should be_success }
    end 
  end 
end
