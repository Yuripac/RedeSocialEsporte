require 'open-uri'
require 'json'

class Api::V1::ApiController < ActionController::Base

  protect_from_forgery with: :null_session

  def id_by_token(access_token)
    uri = open("https://graph.facebook.com/me?access_token="+access_token).read
    json_result = JSON.parse(uri)

    return json_result['id'] if json_result[:error].nil?

    failure(json_result)
  end

  def failure(errors)
    render status: :unauthorized, json: { success: false,
                                          data: {},
                                          error: errors
                                        }
  end

end