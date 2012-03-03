require 'oauth'
require 'json'
class LoginController < ApplicationController
  def self.consumer
    OAuth::Consumer.new(
      WeightHistory::Application.config.t_key,
      WeightHistory::Application.config.t_secret,
      { :site => "http://twitter.com" }
    )
  end
 
  def index
  end
 
  def oauth
    # :oauth_callbackに認証後のコールバックURLを指定
    # この場合だとこのコントローラー内の oauth_callback メソッドが実行される
    request_token = LoginController.consumer.get_request_token(
      :oauth_callback => "http://#{request.host_with_port}/history"
    )
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    # twitter.comで認証する
    redirect_to request_token.authorize_url
    return
  end
 
  def oauth_callback
    consumer = IndexController.consumer
    request_token = OAuth::RequestToken.new(
      consumer,
      session[:request_token],
      session[:request_token_secret]
    )
 
    access_token = request_token.get_access_token(
      {},
      :oauth_token => params[:oauth_token],
      :oauth_verifier => params[:oauth_verifier]
    )
 
    response = consumer.request(
      :get,
      '/account/verify_credentials.json',
      access_token, { :scheme => :query_string }
    )
    case response
    when Net::HTTPSuccess
      @user_info = JSON.parse(response.body)
      unless @user_info['screen_name']
        flash[:notice] = "Authentication failed"
        redirect_to :action => :index
        return
      end
    else
      RAILS_DEFAULT_LOGGER.error "Failed to get user info via OAuth"
      flash[:notice] = "Authentication failed"
      redirect_to :action => :index
      return
    end
  end

end
