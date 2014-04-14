Apipie.configure do |config|
  config.app_name                = "PivotPong"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/*.rb"
  config.show_all_examples       = true
end
