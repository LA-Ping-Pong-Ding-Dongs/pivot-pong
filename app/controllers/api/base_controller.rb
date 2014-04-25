class Api::BaseController < BaseController
  skip_before_action :verify_authenticity_token
end
