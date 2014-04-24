class PlayersSearchController < BaseController
  using_service PlayerService

  def index
    self.collection = service.find_by_substring(params[:search])

    respond_to do |format|
      format.js do
        render json: collection.as_json
      end
    end
  end
end
