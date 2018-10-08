require 'rest_client'
require 'json'

class Plino

  BASE_URI = 'https://plino.herokuapp.com/api/'
  API_VERSION = 'v1'

  def spam?(message)
    begin
      options = {
        content_type: :json,
        accept: :json
      }
      json_data = {
        email_text: message
      }.to_json
      response = RestClient.post("#{BASE_URI}#{API_VERSION}/classify/", json_data, options)
      if response.code == 200
        result = JSON.parse(response.body)
        result["email_class"] == "spam"
      else
        false
      end
    rescue => e
      false
    end
  end

private

  def api_url
    "#{BASE_URI}#{API_VERSION}"
  end

end