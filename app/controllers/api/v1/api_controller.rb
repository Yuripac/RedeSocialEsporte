require 'open-uri'
require 'json'

class Api::V1::ApiController < ActionController::Base

  protect_from_forgery with: :null_session

  # Must returns user's id from facebook if access_token is valid.
  def id_by_token
    json_result = check_access_token

    return json_result[:id] if json_result[:error].nil?

    failure(json_result)
  end

  def check_access_token
    uri = open("https://graph.facebook.com/me?access_token=#{params[:access_token]}").read
    JSON.parse(uri, symbolize_names: true)
  end

  #def success
  #end

  def failure(errors)
    render status: :unauthorized, json: { success: false,
                                          data: {},
                                          info: '',
                                          error: errors
                                        }
  end

  def is_logged_in?
    @user = User.find_by(access_token: params[:access_token])
    !@user.nil?
  end

  # Must control passed params
  #def api_params
  #end

end