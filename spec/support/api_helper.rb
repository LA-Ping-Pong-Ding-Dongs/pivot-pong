module ApiHelper
  def response_json
    JSON(response.body).deep_symbolize_keys
  end
end
